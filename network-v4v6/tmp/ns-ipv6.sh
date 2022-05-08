#!/bin/bash

set -x

if [[ $EUID -ne 0 ]]; then
   echo "You must run this script as root."
   exit 1
fi

VETH1_IPV6=fd00::1
VPEER1_IPV6=fd00::2

# Clean up.
ip netns del ns-ipv6 &>/dev/null
ip li del veth1 &> /dev/null

# Create network namespace.
ip netns add ns-ipv6

# Create veth pair.
ip li add name veth1 type veth peer name vpeer1

# Setup veth1 (host).
ip -6 addr add ${VETH1_IPV6}/64 dev veth1
ip li set dev veth1 up

# Setup vpeer1 (network namespace).
ip li set dev vpeer1 netns ns-ipv6
ip netns exec ns-ipv6 ip li set dev lo up
ip netns exec ns-ipv6 ip -6 addr add ${VPEER1_IPV6}/64 dev vpeer1
ip netns exec ns-ipv6 ip li set vpeer1 up

# Make vpeer1 default gw.
ip netns exec ns-ipv6 ip -6 route add default dev vpeer1 via ${VETH1_IPV6}

# NAT
sysctl -w net.ipv6.conf.all.forwarding=1
ip6tables -t nat --flush
ip6tables -t nat -A POSTROUTING -o he-ipv6 -j MASQUERADE

# Get into ns-ipv6.
ip netns exec ns-ipv6 /bin/bash --rcfile <(echo "PS1=\"ns-ipv6> \"")

# https://blogs.igalia.com/dpino/2016/05/02/network-namespaces-ipv6/
