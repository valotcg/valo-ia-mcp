#!/usr/bin/env sh
# Handshake and tool listing: no API key needed.
# Tool calls need: -H "Authorization: Bearer $VALO_DATA_API_KEY"

curl -sS -X POST "https://api.valotcg.com/mcp" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-11-25","capabilities":{},"clientInfo":{"name":"curl","version":"0"}}}'

echo
curl -sS -X POST "https://api.valotcg.com/mcp" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
