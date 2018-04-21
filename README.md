# oxgithub/cups-airprint
Based on quadportnick/cups-airprint.

This Ubuntu-based Docker image runs a CUPS instance that is meant as an AirPrint relay for printers that are already on the network but not AirPrint capable. I'm using it on a Synology NAS because the built in server doesn't work properly with my printers. The local Avahi will be utilized for advertising the printers on the network.

## Change
* Switched to ubuntun LTS
Can override mirror setting using environment variable MIRROR
* Added ability to install additional drivers

## TODO
* Move additional drivers installation out of the image build process,
Call install_drivers.sh after container launch.

## Issues
* Can not persists printer configuration because some drivers create configuration outside of CUPS `/config`.  

## Build
### Adding Additional Drivers
* Download the drivers and place them under drivers folder 
* Create install_`PrinterModel`_driver.sh in drivers to install it during the build.

### Provided install scripts
* install_brother_lpr_driver.sh
Brother Cupswrapper Driver: http://support.brother.com/g/s/id/linux/en/instruction_prn1a.html
* install_canon_UFRII_driver.sh
Canon UFRII

## Prereqs
* No other printers should be shared under Control Panel>External Devices>Printer so that the DSM's CUPS is not running.
* `Enable Bonjour service discovery` needs to be marked under Control Panel>Network>DSM Settings

## Configuration

### Volumes:
* `/config`: where the persistent printer configs will be stored
* `/services`: where the Avahi service files will be generated

### Variables:
* `CUPSADMIN`: the CUPS admin user you want created
* `CUPSPASSWORD`: the password for the CUPS admin user

### Ports:
* `631`: the TCP port for CUPS must be exposed

## Using
CUPS will be configurable at http://[diskstation]:631 using the CUPSADMIN/CUPSPASSWORD when you do something administrative.

If the `/services` volume isn't mapping to `/etc/avahi/services` then you will have to manually copy the .service files to that path at the command line.

## Notes
* CUPS doesn't write out `printers.conf` immediately when making changes even though they're live in CUPS. Therefore it will take a few moments before the services files update
* Don't stop the container immediately if you intend to have a persistent configuration for this same reason
