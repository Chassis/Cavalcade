# Cavalcade for Chassis

This is an [extension for Chassis](http://docs.chassis.io/en/latest/extend/) to enable [Cavalcade](https://github.com/humanmade/Cavalcade).

Cavalcade is a replacement for WordPress' built-in cron that runs as a daemon on your system. It horizontally scales in production to ensure your scheduled tasks keep up with the scale of your site.

This extension sets up the Cavalcade Runner as a daemon on your system to allow you to replicate production much more easily.

## Installation

This extension can be installed the same as any other Chassis extension:

```
# Clone this repository into your Chassis `extensions` directory:
cd extensions
git clone --recursive git@github.com:Chassis/Cavalcade.git cavalcade

# Re-provision your Chassis box
cd ..
vagrant provision
```

You can monitor the Cavalcade Runner by SSHing into your box, then viewing the `/var/log/upstart/cavalcade.log` file. To view it live, simply run `sudo tail -f /var/log/upstart/cavalcade.log`

## Troubleshooting

### Cavalcade isn't running!

If Cavalcade doesn't appear to be running, check `/var/log/syslog` and look for errors with "cavalcade". You can also check the Cavalcade log at `/var/log/upstart/cavalcade.log` for more information.

If you see "cavalcade respawning too fast, stopped", this typically means that your Cavalcade jobs table hasn't been created. Make sure you have Cavalcade installed as an MU plugin on your site, then visit your site to ensure Cavalcade creates this table.
