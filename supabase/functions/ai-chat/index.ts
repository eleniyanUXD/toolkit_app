import "@supabase/functions-js/edge-runtime.d.ts";
import { withSupabase } from "@supabase/server";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

export default {
  fetch: withSupabase(
    { auth: "publishable" },
    async (req, _ctx) => {
      if (req.method === "OPTIONS") {
        return new Response("ok", {
          headers: corsHeaders,
        });
      }

      try {
        const { message } = await req.json();

        if (!message || typeof message !== "string") {
          return Response.json(
            { error: "Message is required." },
            {
              status: 400,
              headers: corsHeaders,
            },
          );
        }

        const geminiApiKey = Deno.env.get("GEMINI_API_KEY");

        if (!geminiApiKey) {
          return Response.json(
            { error: "Gemini API key is not configured." },
            {
              status: 500,
              headers: corsHeaders,
            },
          );
        }

        const response = await fetch(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent",
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "x-goog-api-key": geminiApiKey,
            },
            body: JSON.stringify({
              contents: [
                {
                  parts: [
                    {
                      text: message,
                    },
                  ],
                },
              ],
            }),
          },
        );

        const data = await response.json();

        console.log("Gemini status:", response.status);
        console.log("Gemini response:", JSON.stringify(data));

        if (!response.ok) {
          return Response.json(
            {
              error:
                data?.error?.message ??
                "Gemini request failed.",
            },
            {
              status: response.status,
              headers: corsHeaders,
            },
          );
        }

        const generatedText =
          data?.candidates?.[0]?.content?.parts?.[0]?.text;

        if (!generatedText) {
          return Response.json(
            {
              error: "Gemini returned an empty response.",
            },
            {
              status: 500,
              headers: corsHeaders,
            },
          );
        }

        return Response.json(
          {
            response: generatedText,
          },
          {
            headers: corsHeaders,
          },
        );
      } catch (error) {
        console.error("Function error:", error);

        return Response.json(
          {
            error:
              error instanceof Error
                ? error.message
                : "Something went wrong while processing your request.",
          },
          {
            status: 500,
            headers: corsHeaders,
          },
        );
      }
    },
  ),
};