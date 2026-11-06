# ADR-0001: Use PostgreSQL for the event store

## Status

Accepted

## Context

- The new order platform needs a durable store for domain events.
- Three spikes compared PostgreSQL, EventStoreDB and Kafka with compaction.
- The operations team already runs PostgreSQL in production and has on-call
  runbooks for it.
- Event payloads vary between aggregates and change often.

## Decision

- Use PostgreSQL as the event store, with one append-only table per bounded
  context and JSONB columns for event payloads.
- The team agreed after reviewing the spike results.

## Consequences

- **Positive:** operational familiarity; JSONB gives flexible payloads; no
  separate message broker is needed.
- **Negative:** PostgreSQL is not a true event store, so the team must manage
  retention and archiving itself.
- **Neutral:** projections are built by application code rather than by the
  database.

## Open Questions

- None at this time.
