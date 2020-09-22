# Ipaddr_ext

This is my playground for testing possible extensions to OCaml's [ipaddr](https://github.com/mirage/ocaml-ipaddr) library.

Sources for inspiration:

* https://docs.python.org/3/library/ipaddress.html#module-ipaddress 
* https://realpython.com/python-ipaddress-module/

... and the following post from the German DENOG mailinglist about some IPv4 subnetting gymnastics

TODO add link to original e-mail

		> > Beispiele:
		> > 
		> > Ich habe ein 10.10.0.0/16 und möchte daraus das Netz 10.10.10.0/24 rausschneiden. 
		> > Als Ergebnis hätte ich dann gerne eine Liste der restlichen Netze und die so weit wie möglich aggregiert.

			% python3
			Python 3.5.3 (default, Jan 19 2017, 14:11:04) 
			[GCC 6.3.0 20170118] on linux
			Type "help", "copyright", "credits" or "license" for more information.
			>>> from pprint import pprint
			>>> import ipaddress
			>>> a = ipaddress.ip_network("10.10.0.0/16")
			>>> b = ipaddress.ip_network("10.10.10.0/24")
			>>> pprint(list(a.address_exclude(b)))
			[IPv4Network('10.10.128.0/17'),
			 IPv4Network('10.10.64.0/18'),
			 IPv4Network('10.10.32.0/19'),
			 IPv4Network('10.10.16.0/20'),
			 IPv4Network('10.10.0.0/21'),
			 IPv4Network('10.10.12.0/22'),
			 IPv4Network('10.10.8.0/23'),
			 IPv4Network('10.10.11.0/24')]

		> > Zwei /24 addieren und wenns passt das /23 zurück bekommen, alternativ die beiden /24

			>>> C = [ipaddress.ip_network("10.0.0.0/24"), ipaddress.ip_network("10.0.1.0/24")]
			>>> list(ipaddress.collapse_addresses(C))
			[IPv4Network('10.0.0.0/23')]

			>>> D = [ipaddress.ip_network("10.0.0.0/24"), ipaddress.ip_network("10.0.2.0/24")]
			>>> list(ipaddress.collapse_addresses(D))
			[IPv4Network('10.0.0.0/24'), IPv4Network('10.0.2.0/24')]

		> > Die Kür wäre das dann mit Gruppen von Netzen. Also zwei Listen von Netzen addieren und aggregieren.

			>>> list(ipaddress.collapse_addresses(C+D))
			[IPv4Network('10.0.0.0/23'), IPv4Network('10.0.2.0/24')]

		> > Bei der Subtraktion dann als Ergebnis die in beiden Listen vorhanden Netze und das was jeweils übrig bleibt,
		> > also quasi ein Venn Diagram.

		Hm, ab hier muss man selbst bauen. Hier ist ein schneller Versuch:

			>>> def subtract_subnet(networks, subnet):
			...     for net in ipaddress.collapse_addresses(networks):
			...         if net.overlaps(subnet):
			...             yield from net.address_exclude(subnet)
			...         else:
			...             yield net

			>>> list(subtract_subnet([ipaddress.ip_network("10.0.0.0/24"),
			...                       ipaddress.ip_network("10.0.1.0/24")],
			...                      ipaddress.ip_network("10.0.0.0/25")))
			[IPv4Network('10.0.1.0/24'), IPv4Network('10.0.0.128/25')]

		Vielleicht geht’s auch noch schicker, ist nur ein schneller PoC. 

		Komplette Doku ist hier: https://docs.python.org/3/library/ipaddress.html
