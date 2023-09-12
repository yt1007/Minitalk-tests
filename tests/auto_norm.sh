# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    norm_c.sh                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yetay <yetay@student.42kl.edu.my>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/12 08:03:52 by yetay             #+#    #+#              #
#    Updated: 2023/09/12 08:04:01 by yetay            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

norminette -R CheckDefine *.h;
norminette -R CheckForbiddenSourceHeader *c;
find * -name "*.h" -mindepth 1 -exec norminette -R CheckDefine {} \; ;
find * -name "*.c" -mindepth 1 \
	-exec norminette -R CheckForbiddenSourceHeader {} \; ;
exit 0;
