# arch-config (Ansible para Arch Linux)

Este repositorio configura Arch Linux con paridad funcional respecto a la referencia NixOS (excepto opciones estrictamente NixOS).

## Ejecución

```bash
cd ansible
ansible-playbook -i localhost, site.yml --ask-become-pass
```

## Variables principales

Archivo: `ansible/vars/main.yml`

- `ssh_enabled`: `false` por defecto (paridad con referencia).
- `nvidia_driver_package`: `nvidia` por defecto (driver propietario).
- `aur_install_enabled`: instalación AUR automática opcional (`false` por defecto).
- `aur_helper`: helper AUR a usar (por ejemplo `yay` o `paru`).
- `aur_packages`: lista de paquetes AUR esperados.
- `nwg_hello_enabled`: opcional y separado del greeter activo.

## Estrategia AUR (segura)

Por defecto el playbook **no** instala AUR automáticamente y solo informa de los paquetes pendientes.

Si activas `aur_install_enabled: true`:

- Se verifica que exista `aur_helper`.
- La instalación AUR se ejecuta como el usuario normal (`become_user`), nunca compilando como root.

## Notas de implementación

- Greeter por defecto: **Noctalia + greetd**.
- `nwg-hello` se mantiene opcional y no interfiere con Noctalia.
- SSH permanece opcional y desactivado por defecto.
- Se incluye un tema HyperFluent local básico para GRUB en `ansible/files/grub/hyperfluent/`.
- El “configurationLimit=3” de NixOS no tiene equivalente 1:1 en GRUB de Arch; el resto del arranque (EFI, os-prober, tema, plymouth y parámetros de kernel) sí queda cubierto.
