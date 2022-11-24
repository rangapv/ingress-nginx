#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/rangapv/kubestatus/main/ks.sh) > /dev/null 2>&1
count=0
gcount=0

func() {

t1="$@"

for k in $t1 
do
  if [[ -d "$k" ]]
  then
    ((count+=1))
    func $k/*
elif [[ -f "$k" ]] && (echo "$k" |  grep ".yaml" >>/dev/null 2>&1) || (echo "$k" | grep ".yml" >>/dev/null 2>&1)
#elif [ -f "$k" ] && ( echo "$k" | awk '{split($0,a,"."); if (a[2] = "yaml") print a[2] }')
  then
    g1=`kubectl apply -f $k`
    echo "$g1"
    # echo "$k" | ( grep ".yaml" || grep ".yml" ) 
    #echo "$k" | awk '{split($0,a,"."); if (a[2] = "yaml" || a[2] = "yml") print a[1] a[2] }'
    ((gcount+=1))
  fi
done
}


if [[ ($master -eq 1) || ($node -eq 1) ]]
then
func ./*
echo "the Total file applied are  $gcount"
echo "the Total Directory traversed are $count"
else
	echo "Kubernetes is not running on this box to install Nginx-Ingress controller..aborting install"
fi
