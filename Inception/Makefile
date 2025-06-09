# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: xzhang <marvin@42.fr>                      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/01/17 17:45:56 by xzhang            #+#    #+#              #
#    Updated: 2025/01/17 17:45:57 by xzhang           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Colors
RED    = '\033[1;31m'
GREEN  = '\033[1;32m'
BLUE   = '\033[1;34m'
CYAN   = '\033[0;36m'

# Variables
NAME = inception
USER = xzhang

all: setup up

setup:
	@mkdir -p /home/$(USER)/data/wordpress # stores WordPress data
	@mkdir -p /home/$(USER)/data/mariadb # stores MariaDB data

build:
	@docker compose -f srcs/docker-compose.yml build # Build the Docker images

up:
	@docker compose -f srcs/docker-compose.yml up -d

down: 
	@docker compose -f srcs/docker-compose.yml down

ps:
	docker compose -f srcs/docker-compose.yml ps

enter:
	docker compose -f srcs/docker-compose.yml exec -it $(c) /bin/bash
	
logs:
	docker compose -f srcs/docker-compose.yml logs $(c)

clean: down
	#@docker system prune -a

fclean: clean
	docker compose -f srcs/docker-compose.yml down --rmi all
	@sudo rm -rf /home/$(USER)/data/wordpress
	@sudo rm -rf /home/$(USER)/data/mariadb
	@volumes=$$(docker volume ls -q); if [ -n "$$volumes" ]; then docker volume rm $$volumes; else echo "Volume 404: nothing to remove."; fi
	@rm -rf srcs/requirements/nginx/nginx.crt
	@rm -rf srcs/requirements/nginx/nginx.key

envclean: fclean
	@rm -rf srcs/.env

re: fclean all

.PHONY: all setup build up down clean fclean re envclean

