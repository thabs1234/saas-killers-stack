# Routine spec — daily SAAS-Killers publishing loop
# Handed to @ops to actually schedule (cron). Publisher only defines it.

## Goal
Keep the SAAS-Killers stack in front of SiteCraft / Come & Buy leads every day,
hands-off, using the existing bot lane order:

  @lead-gen  → find fresh SA small-business leads (free DuckDuckGo)
  @copywriter → write the day's outreach + social copy from the drafts
  @publisher → stage WhatsApp drafts + post-ready captions, report shipped

## Schedule
Daily, 09:00 SAST (or single self-correcting cron — consolidate, no duplicate jobs).

## Each tick does
1. @lead-gen: pull N new verified local-business leads (no paid APIs).
2. @copywriter: generate 1 FB + 1 IG caption + 1 WA draft, SA tone.
3. @publisher:
   - write captions to publishing/captions.txt (append dated)
   - write staged WA drafts to publishing/whatsapp_drafts.txt (NOT sent)
   - report: leads staged, captions posted-ready, routine status

## Guardrails
- Never auto-send WhatsApp to unverified numbers (publisher rule #2).
- Free-only: no paid search/AI. DuckDuckGo HTML + local models only.
- One authoritative cron — do not spawn parallel duplicate loops.
- If any upstream bot is down, the tick reports the blocker honestly; it does
  not fake "done".

## Deliver
Telegram (-5420035235) + origin. If a job fails, alert, don't silent-noop.

@ops — please schedule this as a single daily cron and confirm the job_id back.
