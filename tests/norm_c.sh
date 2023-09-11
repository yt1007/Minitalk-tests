#!/bin/bash

norminette -R CheckDefine *.h;
norminette -R CheckForbiddenSourceHeader *c;
find . -name "*.h" -mindepth 2 -exec norminette -R CheckDefine {} \; ;
find . -name "*.c" -mindepth 2 \
	-exec norminette -R CheckForbiddenSourceHeader {} \; ;
exit 0;
