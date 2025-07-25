# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: abessa-m <abessa-m@student.42porto.com>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/08 21:04:23 by abessa-m          #+#    #+#              #
#    Updated: 2025/07/21 14:37:18 by abessa-m         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME			:= miniRT
NAME-BONUS		:= miniRT_bonus
LIBFT			:= libft/libft.a
LIBFT_DIR		:= libft
MINILIBX		:= minilibx-linux/libmlx_Linux.a
MINILIBX_DIR	:= minilibx-linux
##################################################################### Compiler #
CC				:= cc
CFLAGS			+= -Wall -Wextra
CFLAGS			+= -Werror
MLX_FLAGS		:= -L./minilibx-linux -L/usr/lib -lmlx -lXext -lX11 -lm -lz
DEBUG_FLAGS		+= -g
DEBUG_FLAGS		+= -D DEBUG=1
########################################################### Intermidiate steps #
RM				:= rm -f
AR				:= ar rcs
########################################################## Objects and Headers #
INCLUDES		:= -I./include
BUILD_DIR		:= build
SRCS			:=	\
	src/minirt.c															\
																			\
	src/init/finalize.c														\
	src/init/initialize.c													\
	src/init/input_validation.c												\
	src/init/parse_light_cam.c												\
	src/init/parse_objects.c												\
	src/init/parse_utils.c													\
	src/init/parse.c														\
																			\
	src/mlx/colors.c														\
	src/mlx/hooks.c															\
																			\
	src/utils/ft_append_chr.c												\
	src/utils/ft_atof.c														\
	src/utils/ft_debug.c													\
	src/utils/ft_free.c														\
	src/utils/ft_isfloat.c													\
	src/utils/ft_isspace.c													\
	src/utils/ft_malloc.c													\
	src/utils/ft_strcmp.c													\
	src/utils/is_float_triplet.c											\
	src/utils/obj_lst.c														\

OBJS			:= $(SRCS:src/%.c=$(BUILD_DIR)/%.o)
SRCS-BONUS		:=	\

OBJS-BONUS		:= $(SRCS-BONUS:src/%.c=$(BUILD_DIR)/%.o)
###################################################################### Targets #
all: $(NAME)

$(NAME): libft  $(OBJS)
	@\
	echo "$(GRAY)Compile flags:$(COR)	$(CC) $(CFLAGS)"				;	\
	$(CC) $(OBJS) $(INCLUDES) $(LIBFT) $(MLX_FLAGS) -o $(NAME)

$(BUILD_DIR)/%.o: src/%.c
	@mkdir -p $(dir $@)
	@\
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@								&&	\
	echo "$(GRAY)File compiled:$(COR)	$<"

$(LIBFT):
	@\
	make --silent --no-print-directory -C $(LIBFT_DIR)					&&	\
	echo "$(GRAY)Library built:$(COR)	$(LIBFT)"						;	\
	make --silent --no-print-directory -C $(MINILIBX_DIR)				&&	\
	echo "$(GRAY)Library built:$(COR)	$(MINILIBX)"					;	\

libft : mlx $(LIBFT)

bonus: $(NAME-BONUS)

$(NAME-BONUS): $(LIBFT) $(OBJS-BONUS)
	@\
	echo "$(GRAY)Compile flags:$(COR)	$(CC) $(CFLAGS)"				;	\
	$(CC) $(OBJS-BONUS) $(INCLUDES) $(LIBFT) $(MLX_FLAGS) -o $(NAME-BONUS)

clean:
	@\
	make --silent --no-print-directory -C $(LIBFT_DIR) clean			;	\
	make --silent --no-print-directory -C $(MINILIBX_DIR) clean			;	\
	$(RM) -r $(BUILD_DIR)												;	\
	rm -fr *.o *.gch *.exe 				 								;	\
	echo "$(GRAY)Files cleaned.$(COR)"

fclean: clean
	@\
	make --silent --no-print-directory -C $(LIBFT_DIR) fclean			&&	\
	echo "$(GRAY)Libft cleaned.$(COR)"									;	\
	$(RM) $(NAME) $(NAME-BONUS)											&&	\
	echo "$(GRAY)File fcleaned.$(COR)"

re: fclean all
	@echo "$(GRAY)redone$(COR)"

.PHONY: all clean fclean re
#################################################################### mini libX #
MINILIBX_URL := \
	https://cdn.intra.42.fr/document/document/36087/minilibx-linux.tgz
MINILIBX_ARCHIVE := minilibx-linux.tgz

mlx: $(MINILIBX)

$(MINILIBX):
	@\
	if [ ! -d "$(MINILIBX_DIR)" ]; then \
		echo "$(GRAY)MlX for Linux: $(COR) $@ directory not found."		;	\
		echo -n "$(GRAY)MlX for Linux: $(COR) $@ downloading..."		;	\
		curl -s -L -o $(MINILIBX_ARCHIVE) $(MINILIBX_URL)				&&	\
		echo " done."													;	\
		tar -xzf $(MINILIBX_ARCHIVE)									&&	\
		rm -f $(MINILIBX_ARCHIVE)										&&	\
		echo "$(GRAY)MlX for Linux: $(COR) $@ extracted."				;	\
	else																	\
		echo "$(GRAY)MlX for Linux: $(COR) $(MINILIBX_DIR)/"			;	\
	fi
####################################################################### Colors #
COR		:= \033[0m# COlor Remove
PURPLE	:= \033[1;35m# purple
GRAY	:= \033[1;90m# gray
YELLOW	:= \033[1;93m# yellow
BLUE	:= \033[1;96m# blue
######################################################################### Test #
test: CFLAGS += $(DEBUG_FLAGS)
test: fclean $(NAME)
	@\
	echo "\
	$(COR)$(GRAY)========================================== $(NAME) START\
	$(COR)" && \
	\
	valgrind																\
		--track-fds=yes														\
		--show-error-list=yes												\
		--leak-check=full													\
		--show-leak-kinds=all												\
		--track-origins=yes													\
	\
		./miniRT test.rt												;	\
	\
	echo "\
	$(COR)$(GRAY)========================================== $(NAME) END\n\
	$(COR)RETURN VALUE: $$?"											&&	\
	\
		norminette src/ include/											\
		| grep -v OK 														\
		| grep -v 'Setting locale to en_US'								;	\
	echo -n "Norminette error count: "									;	\
		norminette src/ include/ 											\
			| grep -v OK 													\
			| grep -v 'Setting locale to en_US'								\
			| grep -v Error!												\
		| wc -l

valgrind: $(NAME)
	@\
	valgrind																\
		--track-fds=yes														\
		--show-error-list=yes												\
		--leak-check=full													\
		--show-leak-kinds=all												\
		--track-origins=yes													\
	\
		./miniRT test.rt												;	\
	\
		norminette src/ include/											\
		| grep -v OK 														\
		| grep -v 'Setting locale to en_US'								;	\
	echo -n "Norminette error count: "									;	\
		norminette src/ include/ 											\
			| grep -v OK 													\
			| grep -v 'Setting locale to en_US'								\
			| grep -v Error!												\
		| wc -l

exe: fclean $(NAME)
	@\
	./miniRT test.rt													||	\
	echo "RETURN VALUE: $(YELLOW)$$?$(COR)"

run: $(NAME)
	@\
	./miniRT test.rt													||	\
	echo "RETURN VALUE: $(YELLOW)$$?$(COR)"
