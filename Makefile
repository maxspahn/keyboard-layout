.PHONY: all links clean_links install remove

all: links

BACKUP = .backup

link_evdev:
	@if [ ! -f $(BACKUP)/evdev.xml ]; then \
	  if [ ! -d $(BACKUP) ]; then mkdir $(BACKUP); fi; \
	  sudo cp /usr/share/X11/xkb/rules/evdev.xml $(BACKUP)/evdev.xml; \
	  echo "[.backup/evdev.xml] backup file has been created"; \
	fi; \
	if [ ! $$(ls -i /usr/share/X11/xkb/rules/evdev.xml | cut -f1 -d" " ) \
	  -eq $$(ls -i usr/share/X11/xkb/rules/evdev.xml | cut -f1 -d" " ) ]; then \
	  sudo rm -rf /usr/share/X11/xkb/rules/evdev.xml; \
	  sudo ln usr/share/X11/xkb/rules/evdev.xml /usr/share/X11/xkb/rules/evdev.xml; \
	  echo "[/usr/share/X11/xkb/rules/evdev.xml => usr/share/X11/xkb/rules/evdev.xml] hard link has been created"; \
	fi

link_etc_default_keyboard:
	@if [ ! -f $(BACKUP)/keyboard ]; then \
	  if [ ! -d $(BACKUP) ]; then mkdir $(BACKUP); fi; \
	  sudo cp /etc/default/keyboard $(BACKUP)/keyboard; \
	  echo "[.backup/keyboard] backup file has been created"; \
	fi; \
	if [ ! $$(ls -i /etc/default/keyboard | cut -f1 -d" " ) \
	  -eq $$(ls -i etc/default/keyboard | cut -f1 -d" " ) ]; then \
	  sudo rm -rf /etc/default/keyboard; \
	  sudo ln etc/default/keyboard /etc/default/keyboard; \
	  echo "[/etc/default/keyboard => etc/default/keyboard] hard link has been created"; \
	fi

links: link_evdev link_etc_default_keyboard
	@if [ ! -f /usr/share/X11/xkb/symbols/madvo ]; then \
	  sudo ln usr/share/X11/xkb/symbols/madvo /usr/share/X11/xkb/symbols/madvo; \
	  echo "[/usr/share/X11/xkb/symbols/madvo => usr/share/X11/xkb/symbols/madvo] hard link has been created"; \
	fi

install: links
	@setxkbmap -layout madvo

clean_link_evdev:
	@if [ -f $(BACKUP)/evdev.xml ]; then \
	  sudo rm -f /usr/share/X11/xkb/rules/evdev.xml; \
	  sudo cp $(BACKUP)/evdev.xml /usr/share/X11/xkb/rules/evdev.xml; \
	  rm -rf $(BACKUP)/evdev.xml; \
	fi

clean_link_etc_default_keyboard:
	@if [ -f $(BACKUP)/keyboard ]; then \
	  sudo rm -f /etc/default/keyboard; \
	  sudo cp $(BACKUP)/keyboard /etc/default/keyboard; \
	  rm -rf $(BACKUP)/keyboard; \
	fi

clean_links: clean_link_evdev clean_link_etc_default_keyboard
	@sudo rm -f /usr/share/X11/xkb/symbols/madvo

remove: clean_links
	@setxkbmap -layout us
