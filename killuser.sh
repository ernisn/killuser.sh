#!/bin/sh

# 颜色
red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'

#自己的用户编号
CheckMe(){
	user_num_full=$(tty)
	user_num=${user_num_full##/dev/pts/}
}

#在线用户总数
CheckAllUsers(){
#   users_total=`ps -ef | grep sshd | grep @pts | wc -l`
#   这个方法在结束后不会立马更新用户数，先不用了
    users_folder_num=`ls /dev/pts/ | wc -l`
	users_total=$(($users_folder_num-1))
}

#结束用户及其进程
KillUser(){
	if  [ ! -n "$kill_num" ] ; then
		echo -e "${red}输入错误${none}，请确认输入为整数" 
		exit 1
    else
        case "$kill_num" in 
            [0-9]*)  
#    		kill_folder="/dev/pts/""$kill_num"
#			[ ! -d "$kill_folder" ] && echo -e "${red}输入错误${none}，该用户不存在。" && exit 1
#           输入合法性之后再判断吧，先去掉
			[[ $kill_num = $user_num ]] && echo -e "${red}你选了自己${none}，请不要作死。" && exit 1
			pkill -kill -t "pts/""${kill_num}"
			echo -e "已结束 ${green}${kill_num}${none} 号用户及其进程。" 
		    CheckAllUsers
	        echo -e "剩余用户数: ${green}${users_total}${none}" 
#			if [ ! -d "/dev/pts/""${kill_num}" ]; then
#                echo -e "已结束 ${green}${kill_num}${none} 号用户及其进程。" 
#				CheckAllUsers
#	            echo -e "剩余用户数: ${green}${users_total}${none}" 
#			else
#			    echo -e "${red}结束用户失败。${none}" 
#				CheckAllUsers
#	            echo -e "剩余用户数: ${green}${users_total}${none}" 
#           fi
#           任务完成状态判断先不加了
            ;; 
            *)
          	echo -e "${red}输入错误${none}，请确认输入为整数" 
           	exit 1
            ;; 
        esac 
	fi
}

#用户执行操作
DoKill(){
	CheckMe
	CheckAllUsers
	if [ ${users_total} = "1" ]; then
		echo -e "当前终端为唯一 ssh 在线用户，当前用户连接信息: "
		who am i
		exit 1
	else
		echo -e "当前系统共有 ${green}${users_total}${none} 在线用户,连接信息如下: "
		w -s -h
		echo -e "其中当前终端(自己)为 ${green}${user_num}${none} 号用户，请选择要结束会话的用户编号。"
		read -e -p "输入数值进行选择: " kill_num
        KillUser
	fi
}

DoKill
