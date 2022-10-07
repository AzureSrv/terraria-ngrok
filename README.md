# Terraria Server & NGROK (in Docker)

This is the stack I'm using to host my current Terraria server. These images are not being published on any container registry as they're meant to be custom-built to each server admin's use case.

Big shoutout to [@ryansheehan](https://github.com/ryansheehan) for making the original [Terraria Docker Image](https://github.com/ryansheehan/terraria) which was the backbone of this project.

## 3 Core Components

This project is made up of 3 Docker images, brought up using `docker compose`. Here's a quick rundown of what each image does:

### 1.) Terraria

The images hosted in `terraria-server` is a simple derivative of [@ryansheehan's original Terraria Docker Image](https://github.com/ryansheehan/terraria). I found his CI was pretty slow when it came to pushing updates, so I made it a build target instead of an image run. (No shade to Ryan btw, this shade more goes to Relogic for pushing updates at 8PM, the literal hour I tried launching my server with my friends.)

There is a single arg in the docker compose file for this build, `DL_VERSION`, which corresponds to the semver number of the build you wish to run, without the dots. (i.e. 1.4.4.5 -> `1445`)

### 2.) NGROK

This is the tunnel I used because I didn't feel like port-forwarding my home network. This just uses the upstream `wernight/ngrok` image, with little to no tinkering. All you need to do is copy `ngrok/ngrok.env.example` to `ngrok/ngrok.env` and put all of your secrets in there as requested.

### 3.) IP Notifier

This last image is a custom one I built in-house. It was originally intended to interact with Cloudflare's API to update an SRV record to the allocated NGROK address/port, but after realizing that Terraria doesn't support SRV records, I just made it a Discord webhook bot.

Same deal for config here: copy `ddns/ddns.env.example` to `ddns/ddns.env` and put all of your secrets in there as requested.
