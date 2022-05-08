 #!/bin/bash
2 
3 set -x
4 
5 if [[ $EUID -ne 0 ]]; then
6    echo "You must run this script as root."
7    exit 1
8 fi
9 
10 VETH1_IPV6=fd00::1
11 VPEER1_IPV6=fd00::2
12 
13 # Clean up.
14 ip netns del ns-ipv6 &>/dev/null
15 ip li del veth1 &> /dev/null
16 
17 # Create network namespace.
18 ip netns add ns-ipv6
19 
20 # Create veth pair.
21 ip li add name veth1 type veth peer name vpeer1
22 
23 # Setup veth1 (host).
24 ip -6 addr add ${VETH1_IPV6}/64 dev veth1
25 ip li set dev veth1 up
26 
27 # Setup vpeer1 (network namespace).
28 ip li set dev vpeer1 netns ns-ipv6
29 ip netns exec ns-ipv6 ip li set dev lo up
30 ip netns exec ns-ipv6 ip -6 addr add ${VPEER1_IPV6}/64 dev vpeer1
31 ip netns exec ns-ipv6 ip li set vpeer1 up
32 
33 # Make vpeer1 default gw.
34 ip netns exec ns-ipv6 ip -6 route add default dev vpeer1 via ${VETH1_IPV6}
35 
36 # NAT
37 sysctl -w net.ipv6.conf.all.forwarding=1
38 ip6tables -t nat --flush
39 ip6tables -t nat -A POSTROUTING -o he-ipv6 -j MASQUERADE
40 
41 # Get into ns-ipv6.
42 ip netns exec ns-ipv6 /bin/bash --rcfile <(echo "PS1=\"ns-ipv6> \"")

sudo ip link add name veth1 type veth peer name internal-peer
sudo ip -6 addr add fd00::2/64 dev veth1
sudo ip link set dev veth1 up
sudo ip link set dev internal-peer netns isolated
sudo ip netns exec isolated ip li set dev lo up
sudo ip netns exec isolated ip -6 addr add fd00::2/64 dev internal-peer
sudo ip netns exec isolated ip li set internal-peer up
sudo ip netns exec isolated ip -6 route add default dev internal-peer via fd00::1
sudo sysctl -w net.ipv6.conf.all.forwarding=1
sudo ip6tables -t nat --flush
sudo ip6tables -t nat -A POSTROUTING -o he-ipv6 -j MASQUERADE
sudo ip netns exec isolated bash
