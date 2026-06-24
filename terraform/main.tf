# 1. Настройка окружения и провайдера
terraform {
  required_providers {
    twc = {
      source = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
    }
  }
  required_version = ">= 0.13"
}

data "twc_configurator" "second-head-configurator" {
  location = "nl-1"
}

# 2. Переменная для безопасного токена
variable "twc_token" {
  type      = string
  sensitive = true
}

provider "twc" {
  token = var.twc_token
}

# firewall
resource "twc_firewall" "second-head-firewall" {
  name = "second-head-firewall"
  description = "Basic vpn firewall"

  link {
    id   = twc_server.second-head_router.id
    type = "server"
  }
}

# Правило для SSH (TCP 22)
resource "twc_firewall_rule" "ssh_rule" {
  firewall_id = twc_firewall.second-head-firewall.id
  description = "Allow SSH incoming traffic"
  direction   = "ingress"
  protocol    = "tcp"
  port        = 22
  cidr        = "0.0.0.0/0"
}

# Правило для замаскированного Xray VLESS (TCP 443)
resource "twc_firewall_rule" "xray_rule" {
  firewall_id = twc_firewall.second-head-firewall.id
  description = "Allow Xray VLESS-Reality traffic"
  direction   = "ingress"
  protocol    = "tcp"
  port        = 443
  cidr        = "0.0.0.0/0"
}

# Правило для Hysteria2 (UDP 8443)
resource "twc_firewall_rule" "hysteria_rule" {
  firewall_id = twc_firewall.second-head-firewall.id
  description = "Allow Hysteria2 UDP traffic"
  direction   = "ingress"
  protocol    = "udp"
  port        = 8443
  cidr        = "0.0.0.0/0"
}

#  Создаем независимый Плавающий IP в Амстердаме
resource "twc_floating_ip" "second-head-floating-ip" {
  availability_zone = "ams-1"
  ddos_guard        = false
}

#  Создаем сервер CentOS 10 с гибким выбором мощностей
resource "twc_server" "second-head_router" {
  name              = "dynamic-vpn-router"
  preset_id = 3340
  project_id = 2651749
  os_id = 113
  availability_zone = "ams-1"
  is_root_password_required = true

  # ЖЕСТКАЯ СВЯЗКА: Привязываем созданный выше плавающий IP к этому серверу!
  floating_ip_id = twc_floating_ip.second-head-floating-ip.id

  ssh_keys_ids=[twc_ssh_key.second-head-key.id]
}

# Выводим итоговый IP-адрес на экран
output "router_public_ip" {
  value = twc_floating_ip.second-head-floating-ip.ip
}

#ssh key
resource "twc_ssh_key" "second-head-key" {
   name = "Second head"
   body = file("~/.ssh/second-head.pub")
}

