# Valo.IA — MCP server for trading card prices

[![mcptry](https://mcptry.com/badge/com.valotcg/valo-ia)](https://mcptry.com/servers/com.valotcg/valo-ia)
[![MCP Registry](https://img.shields.io/badge/MCP%20Registry-com.valotcg%2Fvalo--ia-blue)](https://registry.modelcontextprotocol.io/v0.1/servers?search=com.valotcg/valo-ia)
[![Glama](https://img.shields.io/badge/Glama-connector-green)](https://glama.ai/mcp/connectors/com.valotcg/valo-ia)

Valo.IA is the hosted [MCP](https://modelcontextprotocol.io) server of [ValoTCG](https://valotcg.com)'s developer API. It gives an AI agent the card catalogue, dated prices and graded data that power the ValoTCG app, for Pokémon and 13 other trading card games (14 in total).

- **Endpoint:** `https://api.valotcg.com/mcp` (Streamable HTTP, stateless, JSON responses)
- **Registry name:** `com.valotcg/valo-ia`
- **Auth:** `Authorization: Bearer <Valo.Data API key>` — `initialize` and `tools/list` work without a key; tool calls need one
- **Data:** Cardmarket (EUR), US market (USD), eBay sales (EUR), graded eBay sales, PSA and CCC populations, sealed products, price history
- **Docs:** <https://valotcg.com/developers/docs> · **Product page:** <https://valotcg.com/developers/ia>

This repository holds the public metadata of the server (`server.json`), setup instructions and examples. The server itself runs on ValoTCG's infrastructure; nothing needs to be installed or built from here.

## Quick start

1. Create a free Sandbox key at <https://valotcg.com/developers/account> (no credit card). Keys look like `vd_test_…` (Sandbox) or `vd_live_…` (paid plans).
2. Add the server to your client.

**Claude Code**

```sh
claude mcp add --transport http valotcg https://api.valotcg.com/mcp \
  --header "Authorization: Bearer $VALO_DATA_API_KEY"
```

**Cursor, VS Code, Windsurf and other JSON-configured clients**

```json
{
  "mcpServers": {
    "valotcg": {
      "type": "streamable-http",
      "url": "https://api.valotcg.com/mcp",
      "headers": {
        "Authorization": "Bearer vd_live_…"
      }
    }
  }
}
```

3. Ask your agent something like *"What is the current Cardmarket price of Charizard ex 199/165 from 151, French print?"* — it will call `identify_card` then `get_card_prices` or `price_summary`.

## Tools

All 16 tools are read-only and idempotent. Each call is metered in Valo.Data credits (the credit cost is documented per tool in `tools/list`); an error is never billed.

| Tool | What it does |
| --- | --- |
| `list_games` | The 14 games, their card languages and per-source coverage. Free. |
| `list_editions` | Sets and expansions of a game, searchable by name or set code. |
| `search_cards` | Search cards by name (FR/EN), number, edition, language or rarity. |
| `get_card` | One card sheet: name, number, rarity, image, Cardmarket and US market ids. |
| `get_card_prices` | Current prices of a card per source, each dated; optional graded medians and PSA/CCC populations. |
| `get_cards_batch` | Prices for up to 100 cards or sealed products in one call. |
| `get_price_history` | Daily history of one source for a card, up to 365 days, one point per observed day. |
| `search_sealed` | Search sealed products (boosters, displays, ETBs, boxes). |
| `get_sealed_prices` | Current prices of a sealed product per source. |
| `identify_card` | Find a card from free text such as "dracaufeu 199 151 fr". |
| `price_summary` | Recommended price, reliability and recent changes of a card or sealed product. |
| `compare_prices` | Price summaries of up to 10 cards and sealed products side by side. |
| `top_movers` | Largest price rises or falls of a game or an edition over 7, 30 or 90 days. |
| `top_priced` | Most valuable cards or sealed products of a game, an edition or a language. |
| `edition_overview` | Chase cards, sealed products and price coverage of an edition. |
| `scan_card` | Recognise a card from a photo and return its Valo.Data ids (keys with the Vision scope only). |

A quote that does not exist comes back with `status: "missing"` and a null amount, never an invented figure. Every price carries its source, currency and observation date; nothing is converted between currencies.

## Behaviour and limits

- `initialize` and `tools/list` answer without a key, so directories and clients can inspect the server. A `tools/call` without a valid key returns a tool error (`invalid_api_key`, not billed) pointing to the key page.
- `GET` and `DELETE` on `/mcp` return `405`: the server is stateless, without SSE streams or sessions.
- Coverage differs by game; the live matrix is at <https://valotcg.com/developers/coverage>.
- The Sandbox key is for prototyping and non-commercial use; paid plans add the commercial licence. Prices are net, VAT not applicable (art. 293 B of the French tax code). Plans: <https://valotcg.com/developers/pricing>.

## Links

- Official MCP Registry: <https://registry.modelcontextprotocol.io/v0.1/servers?search=com.valotcg/valo-ia>
- Glama: <https://glama.ai/mcp/connectors/com.valotcg/valo-ia>
- mcptry: <https://mcptry.com/servers/com.valotcg/valo-ia>
- REST API (same key, same data): <https://valotcg.com/developers/api/pokemon>
- Contact: <contact@valotcg.com>

## Licence

The files in this repository are released under the MIT licence (see `LICENSE`). Use of the Valo.IA service itself is governed by the [API terms](https://valotcg.com/developers/terms).
