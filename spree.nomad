job "spree" {
  region = "example"
  datacenters = ["example"]

  constraint {
    attribute = "${attr.kernel.name}"
    value = "linux"
  }

  group "spree" {
    count = 1
    ephemeral_disk {
      size  = "300"
    }
    restart {
      attempts = 10
      interval = "60s"
      delay = "5s"
      mode = "delay"
    }

    task "spree" {
      driver = "docker"
      config {
        network_mode = "host"
        image = "danaps/spree:latest"
        port_map {
          web    = 3000
        }
      }

      template {
        splay = "180s"
        left_delimiter = "<<<"
        right_delimiter = ">>>"
        data = <<EOH
<<<- range tree "spree" >>>
<<<.Key | toUpper |replaceAll "/"  "_">>>="<<<.Value>>>"<<<end>>>
EOH
        destination = "secrets/envvars"
        env         = true
      }

       resources {
        cpu = 1000
        memory = 1024
        network {
          mbits = 10
          port "web" {
            static = 3000
          }
        }
      }

      service {
        port = "web"
        name = "spree"
        check {
          port     = "web"
          type     = "tcp"
          interval = "5s"
          timeout  = "2s"
        }
      }
    }
  }
}
