#!/bin/bash
f1="/home/ubuntu/uping/nginx-ingress:2.4.1/*"

func() {

t1="$@"
#echo "t1 is $t1"

for k in $t1 
do
  if [[ -d "$k" ]]
  then
   # echo "Before recursion $count and k is $k"
    ((count+=1))
    func $k/*
elif [[ -f "$k" ]] && (echo "$k" |  grep ".yaml" ) || (echo "$k" | grep ".yml")
#elif [ -f "$k" ] && ( echo "$k" | awk '{split($0,a,"."); if (a[2] = "yaml") print a[2] }')
  then
    g1=`kubectl apply -f $k`
    echo "g1 is $g1"
    # echo "$k" | ( grep ".yaml" || grep ".yml" ) 
    #echo "$k" | awk '{split($0,a,"."); if (a[2] = "yaml" || a[2] = "yml") print a[1] a[2] }'
    ((gcount+=1))
    #cp -r $k $dest
  fi
done
}

func ./*
echo "the Total file applied are  $gcount"
echo "the Total Directory traversed are $count"
