/certificate
import file=mikrotik.crt
import file=mikrotik.pem
import file=ca.crt



/interface ovpn-client add \
name=agusprasetia-vpn connect-to=1.1.1.1 auth=sha1 cipher=aes256 \
certificate=mikrotik.crt_0 profile=default port=1194 mode=ip \
add-default-route=no comment=agusprasetia-vpn user=aghe password=123456
