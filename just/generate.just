# Generate stable MAC address
@mac host interface='':
  echo "{{host}}{{interface}}"|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/'

# Generate hostId
@hostId:
  head -c4 /dev/urandom | od -A none -t x4
