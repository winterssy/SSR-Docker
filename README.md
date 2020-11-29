# SSR-Docker
使用Docker部署ShadowsocksR服务端

[![Actions Status](https://github.com/winterssy/SSR-Docker/workflows/Publish%20Docker/badge.svg)](https://github.com/winterssy/SSR-Docker/actions)

## [BBR加速](https://github.com/iMeiji/shadowsocks_install/wiki)
BBR 目的是要尽量跑满带宽, 并且尽量不要有排队的情况，效果并不比速锐差。Linux kernel 4.9+已支持tcp_bbr，下面简单讲述基于KVM架构VPS如何开启。

### Ubuntu 14.04

- 下载最新内核，最新内核查看[这里](http://kernel.ubuntu.com/~kernel-ppa/mainline)  
```
$ wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.16/linux-image-4.16.0-041600-generic_4.16.0-041600.201804012230_amd64.deb
```

- 安装内核
```
$ sudo dpkg -i linux-image-4.*.deb
```

- 删除旧内核(可选)
```
$ sudo dpkg -l | grep linux-image
$ sudo apt-get purge -y linux-image-4.4.*
```

- 更新 grub 系统引导文件并重启
```
$ sudo update-grub
$ sudo reboot
```

### Ubuntu 16.04

- 安装 Hardware Enablement Stack (HWE) ，自动更新内核
```
$ sudo apt install --install-recommends linux-generic-hwe-16.04
```

- 删除旧内核(可选)
```
$ sudo apt autoremove
```

### 开启bbr
开机后 `uname -r` 看看是不是内核 >= 4.9

执行 `lsmod | grep bbr` ，如果结果中没有 `tcp_bbr` 的话就先执行
```
$ echo "net.core.default_qdisc=fq" | sudo tee --append /etc/sysctl.conf
$ echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee --append /etc/sysctl.conf
```

保存生效
```
$ sudo sysctl -p
``` 

执行
```
$ sudo sysctl net.ipv4.tcp_available_congestion_control
$ sudo sysctl net.ipv4.tcp_congestion_control
```
如果结果都有 `bbr` ，则证明你的内核已开启 bbr  

执行 `lsmod | grep bbr` ，看到有 tcp_bbr 模块即说明 bbr 已启动

## 安装Docker
```
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
$ sudo usermod -aG docker $USER
```

## 安装Docker Compose
```
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

## 部署SSR-Docker
```
$ git clone https://github.com/winterssy/SSR-Docker.git ~/SSR-Docker
$ cd ~/SSR-Docker
$ docker-compose up -d
```

## SSR-Docker管理命令
```
$ cd ~/SSR-Docker
```
启动 ShadowsocksR：
```
$ docker-compose start ssr
```
停止 ShadowsocksR：
```
$ docker-compose stop ssr
```
重启 ShadowsocksR：
```
$ docker-compose restart ssr
```
查看日志：
```
$ docker-compose logs -f ssr
```
## ShadowsocksR节点配置
参考 https://github.com/iMeiji/shadowsocks_install/blob/master/shadowsocksR-wiki/config.json.md

的说明修改 `etc/config.json` ，同步更新 `docker-compose.yml` 中的端口映射，然后重新部署容器，命令如下：
```
$ cd ~/SSR-Docker
$ docker-compose down
$ docker-compose up -d
```
