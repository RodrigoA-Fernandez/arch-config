# arch-config (Ansible para Arch Linux)

Este repositorio configura Arch Linux con paridad funcional frente a la referencia NixOS, excluyendo explícitamente opciones que son propias de NixOS.

## Ejecución

```bash
cd ansible
ansible-playbook -i localhost, site.yml --ask-become-pass
```

## Prerrequisitos

- Usuario normal definido en `username` (se usa para compilación AUR, nunca root).
- Si `aur_install_enabled: true`, debe existir `aur_helper` (por ejemplo `yay` o `paru`).
- Si `nwg_hello_enabled: true`, se requiere un wallpaper válido en `nwg_hello_wallpaper_source` (o desactivar `nwg_hello_wallpaper_required`).

## Comportamiento AUR (requerido vs opcional)

Variables clave en `ansible/vars/main.yml`:

- `aur_install_enabled` (por defecto `false`): instalación automática AUR.
- `aur_required_packages`: paquetes AUR requeridos.
- `aur_optional_packages`: paquetes AUR opcionales.
- `nix_compat_enabled`: activa paquetes AUR de compatibilidad Nix (`nix_compat_aur_packages`).

Estrategia:

- Con `aur_install_enabled: true`, los paquetes AUR se instalan como `become_user: {{ username }}`.
- Con `aur_install_enabled: false`, el playbook verifica que los paquetes AUR **requeridos** ya existan y falla con mensaje claro si faltan.
- Los paquetes AUR opcionales no bloquean toda la ejecución.
- `noctalia-greeter` se trata como requerido cuando `noctalia_greeter_enabled: true`.

## Greeters y display manager

- Predeterminado: **greetd + Noctalia**.
- `nwg-hello` es opcional (`nwg_hello_enabled`) y se instala en `/etc/nwg-hello/*` desde `display/nwg-hello/`.
- SDDM es opcional (`sddm_enabled: false` por defecto) y no debe habilitarse junto con `greetd + Noctalia`.

## Decisiones explícitas de paridad

- `xorg_compat_enabled: false` por defecto (objetivo principal: Hyprland/Wayland; XWayland se instala con Hyprland). Puedes activar compatibilidad Xorg explícita.
- `pulseaudio_compat_enabled: false` por defecto. PipeWire (incluido `pipewire-pulse`) sigue siendo la pila de audio principal.
- `dbus_enabled: true` habilita DBus de forma idempotente seleccionando `dbus-broker.service` o `dbus.service` según disponibilidad.
- `graphics_32bit` controla también `lib32-nvidia-utils`.

## Firewall Steam

Se mantienen por defecto los puertos equivalentes de referencia:

- TCP: `1701, 5900, 53317`
- UDP: `1701, 1716, 53317`

Opciones adicionales (desactivadas por defecto):

- `steam_remote_play_firewall_enabled`
- `steam_dedicated_server_firewall_enabled`

Las listas de puertos se combinan sin duplicados antes de generar `nftables`.

## Tema GRUB HyperFluent

El tema local en `ansible/files/grub/hyperfluent/theme.txt` se mantiene autocontenido (sin referencias a assets no presentes en el repositorio).

## Exclusiones NixOS (intencionales)

No se migran como “paridad Arch” por ser Nix/NixOS-específico:

- `nix.gc`, `nixpkgs.config`, flakes y estado interno NixOS (`system.stateVersion`)
- imports y módulos NixOS
- ACLs de `/etc/nixos`

Además, paquetes de compatibilidad Nix (`nix-direnv`, etc.) quedan detrás de `nix_compat_enabled`.
