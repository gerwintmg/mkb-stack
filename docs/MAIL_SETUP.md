# Mail Setup

## Optie 1: Relay (aanbevolen)
- Lokaal verkeer → Postfix relay container → Office365 of andere provider.
- Eenvoudig, minder kans op blacklisting.

## Optie 2: Volwaardige Mailserver (geavanceerd)
- Installeer Postfix + Dovecot + Rspamd.
- Vereist DNS configuratie (MX, SPF, DKIM, DMARC).
- Meer beheer, maar volledige controle.
