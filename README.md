# SSR-Docker
使用Docker部署ShadowsocksR服务端，基于 `Ubuntu18.04` 。

> 由于 `ShadowsocksR` 年久失修，建议大家尽可能迁移使用 [V2Ray](https://www.v2fly.org/) 或者 [Trojan](https://github.com/trojan-gfw/trojan) 。

[![Actions Status](https://img.shields.io/github/workflow/status/winterssy/SSR-Docker/Publish%20Docker/master?label=Publish%20Docker&logo=appveyor)](https://github.com/winterssy/SSR-Docker/actions)

## BBR加速
部分VPS厂商如搬瓦工的机器已默认开启BBR加速，你可执行 `lsmod | grep bbr` 命令查看，如果结果中有 `tcp_bbr` 的话表示已开启BBR，没有可手动执行以下命令开启。
```sh
$ echo "net.core.default_qdisc=fq" | sudo tee --append /etc/sysctl.conf
$ echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee --append /etc/sysctl.conf
$ sudo sysctl -p
```

## 安装Docker
```sh
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
$ sudo usermod -aG docker $USER
```

## 安装Docker Compose
```sh
$ compose_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
$ sudo curl -L "https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

## 部署SSR-Docker
```sh
$ git clone https://github.com/winterssy/SSR-Docker.git ~/SSR-Docker
$ cd ~/SSR-Docker
$ docker-compose up -d
```

## SSR-Docker管理命令
```sh
$ cd ~/SSR-Docker
```
启动 ShadowsocksR：
```sh
$ docker-compose start ssr
```
停止 ShadowsocksR：
```sh
$ docker-compose stop ssr
```
重启 ShadowsocksR：
```sh
$ docker-compose restart ssr
```
查看日志：
```sh
$ docker-compose logs -f ssr
```
