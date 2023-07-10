{
    "service": {
      "id": "${service_name}",
      "name": "${service_name}",
      "tags": [
          "${tags}"
        ],
      "port": ${port},
      "connect": {
        "sidecar_service": {}
        },
      "checks": [
        {
          "id": "ssh",
          "name": "TCP on port ${port}",
          "tcp": "localhost:${port}",
          "interval": "10s",
          "timeout": "1s"
        }
      ]
  }
}