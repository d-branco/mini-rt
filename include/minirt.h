/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   minirt.h                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abessa-m <abessa-m@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/08 21:10:24 by abessa-m          #+#    #+#             */
/*   Updated: 2025/07/10 16:14:09 by abessa-m         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef MINIRT_H
# define MINIRT_H

# include "../libft/libft.h"
# include "../minilibx-linux/mlx.h"
# include <math.h>
# include <fcntl.h>

# ifndef DEBUG
#  define DEBUG FALSE
# endif

# define TRUE				1
# define FALSE				0

typedef struct s_rt
{
	int						file_fd;
	struct s_scene			*scene;
}							t_rt;

//subject to change
typedef struct s_scene
{
	float					amb_ratio;
	int						amb_rgb_range[3];
	float					cam_coord[3];
	float					cam_orientation[3];
	int						cam_fov;
	float					light_coord[3];
	float					light_brightness_ration;
	int						light_rgb_range[3];
	struct s_lst_obj		*lst_obj;
}							t_scene;

enum	e_obj
{
	e_SPHERE,
	e_PLANE,
	e_TRIANGLE
};

typedef struct s_lst_obj
{
	int						identifier;
	float					center[3];
	float					diameter;
	int						rgb_range[3];
	float					vec_uni[3];
	float					height;
	struct s_lst_obj		*next;
}							t_lst_obj;

//src/init/finalize.c
void		finalize(t_rt *rt);
//src/init/input_validation.c
int			input_validation(int argc, char **argv, t_rt *rt);
//src/utils
void		debug_write(char *str);
void		ft_free_n_null(void **ptr);
int			ft_isspace(char chr);
void		*ft_malloc(int total_size);
int			ft_strcmp(const char *s1, const char *s2);

#endif
