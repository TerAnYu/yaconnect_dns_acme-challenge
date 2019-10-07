@echo off
cd "%~dp0"
powershell -executionPolicy bypass -Command ".\dns_acme-challenge.ps1 %*



REM https://github.com/PKISharp/win-acme/wiki/DNS-validation-plugins
REM https://yandex.ru/dev/pdd/doc/concepts/access-docpage/


REM powershell -executionPolicy bypass -Command  D:\yandex_dns\dns_acme-challenge.ps1 create {Identifier} {RecordName} {Token}
REM powershell -executionPolicy bypass -Command  D:\yandex_dns\dns_acme-challenge.ps1 create example.com _acme-challenge.example.com YgZXfGznJBDTEMpip1g_x4g2ah7QSoU_CJsPInDG2fM

REM powershell -executionPolicy bypass -Command  D:\yandex_dns\dns_acme-challenge.ps1 delete {Identifier} {RecordName} {Token}
REM powershell -executionPolicy bypass -Command  D:\yandex_dns\dns_acme-challenge.ps1 delete example.com _acme-challenge.example.com YgZXfGznJBDTEMpip1g_x4g2ah7QSoU_CJsPInDG2fM

