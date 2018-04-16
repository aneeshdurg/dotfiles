if [ $(iwgetid -r) != IllinoisNet ]
then
  vpn=$(ps aux | grep cisco/anyconnect/bin/vpnui | grep -v grep | wc -l)
  if [ $vpn -eq 0 ]
  then
    exit 0
  fi
fi
exit 1
