/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_debug.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abessa-m <abessa-m@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/10 13:25:32 by abessa-m          #+#    #+#             */
/*   Updated: 2025/07/10 16:20:55 by abessa-m         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minirt.h"

void	debug_write(char *str)
{
	size_t	len;

	if (!DEBUG || !str || !str[0])
		return ;
	write(STDOUT_FILENO, "||DEBUG|| ", 10);
	len = ft_strlen(str);
	write(STDOUT_FILENO, str, len);
}
