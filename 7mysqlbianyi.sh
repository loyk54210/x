#!/bin/bash
mysql_boost_link=https://niumapan.top/directlink/3/centos7-yum%E6%BA%90/mysql-boost-5.7.44.tar.gz
#-----------------------进度条函数----------
Dynamic_Pbar(){
		echo -n "-"
	        sleep 0.1
	        echo -n "-"
	        sleep 0.09
	        echo -n "--"
	        sleep 0.08
	        echo -n "---"
	        sleep 0.08
	        echo -n "-----"
	        sleep 0.08
	        echo -n "------"
	        sleep 0.08
	        echo -n "-------"
	        sleep 0.08
	        echo -n "--------"
	        sleep 0.08
	        echo -n "---------"
	        sleep 0.07
	        echo -n "----------"
	        sleep 0.07
	        echo -n "-----------"
	        sleep 0.07
	        echo -n "-------------"
	        sleep 0.07
	        echo -n "--------------"
	        echo
	        sleep 0.07
	        sleep 0.1

}
#-------小进度条函数-----彩色
Dynamic_Pbar02(){
		echo -n -e "\e[31m--\e[0m"
	        sleep 0.1
	        echo -n -e "\e[32m---\e[0m"
	        sleep 0.09
	        echo -n -e "\e[33m----\e[0m"
	        sleep 0.08
	        echo -n -e "\e[34m----\e[33m---\e[0m\e[0m"
	        sleep 0.08
	        echo -n -e "\e[31m----\e[0m-\e[32m---\e[0m"
	        sleep 0.08
	        echo -n -e "\e[35m-------\e[0m"
	        sleep 0.08
	        echo -n -e "\e[36m-----\e[0m"
	        sleep 0.08
	        echo -n -e "\e[37m-----\e[0m"
	        sleep 0.08
	        echo  -e "\e[33m---\e[0m"
	        echo
	        sleep 0.07
	        sleep 0.1

}
while true
do
	echo "1.一键编译安装mysql5.7"
	# 待优化，可以弄成用户输入是编译安装还是yum安装的，进行初始化
	echo -e "\e[93m2.忘记密码重新初始化编译安装的mysql\e[0m"
	echo "3.yum安装mysql5.7或者8.0"
	echo -e "\e[92m按0返回上一个面板\e[0m"
	read -p "请输入命令，以回车结束：" commd05
	case "$commd05" in
	1) 
		echo -n -e "\e[93m 编译安装慢得很，电脑不好别安装请自行确认是否应该编译安装mysql,确认按y/yes回车，返回输入任意值：\e[0m" && read -p "" mysql_install_confirm
		if [[ $mysql_install_confirm == "y" || $mysql_install_confirm == "Y" || $mysql_install_confirm == "yes" || $mysql_install_confirm == "YES" ]];then
			echo "即将下载mysql_bost包......"
			#来个小进度条函数
			Dynamic_Pbar02
			yum -y install wget && wget "$mysql_boost_link"  
			echo -e "\e[93m正在检查清理...\e[0m"
			#加一个进度条函数
			Dynamic_Pbar
			yum erase mariadb mariadb-server mariadb-libs mariadb-devel -y >/dev/null
			userdel -r mysql && rm -rf /etc/my*
			rm -rf /var/lib/mysql
			useradd -r mysql -M -s /sbin/nologin
			yum -y install ncurses ncurses-devel openssl-devel bison gcc gcc-c++ make cmake >/dev/null
			mkdir -p /usr/local/{data,mysql,log} && tar -xzvf mysql-boost-5.7.44.tar.gz -C /usr/local/ && cd /usr/local/mysql-5.7.44
			echo -e "\e[95m即将开始编译安装....不是卡住，是为了加速安装，已经改为屏幕不打印正确信息\e[0m" && sleep 3
			cmake . \
-DWITH_BOOST=boost/boost_1_59_0/ \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DSYSCONFDIR=/etc \
-DMYSQL_DATADIR=/usr/local/mysql/data \
-DINSTALL_MANDIR=/usr/share/man \
-DMYSQL_TCP_PORT=3306 \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_READLINE=1 \
-DWITH_SSL=system \
-DWITH_EMBEDDED_SERVER=1 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 >/dev/null
			echo -e "\e[91m即将进入漫长等待请勿关闭，为了加速安装，已经改为屏幕不打印正确信息！\e[0m" && echo -e "\e[91m 切记，不是卡住！不是卡住！耐心等待 \e[0m" 
			make -j2  && make install  && echo -e "\e[92m编译完成，即将写入服务..\e[0m"
			#加一个进度条函数
			Dynamic_Pbar02
			echo -e "\e[93m正在对文件授权..\e[0m"
			#加一个进度条函数
			Dynamic_Pbar02
			cd /usr/local/ && chown -R mysql:mysql mysql
			#--初始化编译安装的mysql并且随机临时密码，记录到mysql_tmp_pass.txt中
			/usr/local/mysql/bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data &>mysql_tmp_pass.txt
			show_mysql_tmp_pass=`grep "temporary password" mysql_tmp_pass.txt |awk '{print "你的mysql临时密码是: "$NF}'`
			color01="\e[93m"
			color02="\e[0m"
			clear
			echo -e "${color01}${show_mysql_tmp_pass}${color02}"
			echo -e "\e[95mps：如果不记得了就vim当前文件夹下的mysql_tmp_pass.txt文件自己看～\e[0m"
			cp /usr/local/mysql/support-files/mysql.server  /etc/init.d/
			chkconfig --add mysql.server
			systemctl daemon-reload
			echo export PATH=/usr/local/mysql/bin:'$PATH' >>/etc/profile
			source /etc/profile
			source /etc/profile
			source /etc/profile && clear && echo -e "\e[38;5;208mmysql编译安装成功\e[0m"
			else
				break

		fi
		;;

	2)
		#--重新初始化编译安装mysql且让mysql为空密码
		sudo rm -rf /usr/local/mysql/data
		sudo /usr/local/mysql/bin/mysqld --initialize-insecure --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
		clear && echo -e "\e[93mmysql初始化完成，密码现在为空\e[0m"
		;;
	3)
		echo
		;;
	0)
		break
	esac
done
