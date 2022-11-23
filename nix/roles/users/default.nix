{ config, pkgs, ... }:
let inherit (pkgs.lib) mkMerge mkIf;
in
{
  users.users.erin = mkMerge [
    {
      isNormalUser = true;
      extraGroups = [ "wheel" ];

      openssh.authorizedKeys.keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDwJT+cXE/+JyYMIbShC/PSF7uHoFCg+xaW32eTMBzo3o/hajPpq7GR0+kUuw9g7cM3V9RffTX0bHDt7QkehiuIMhDxX7Eg4nIPipSOycE9zG9jhdfdHydFmvk3oskc7z4+DUm+L6y8j89c8WtYZsEmTX+ktV09Gg/IRjzvO5wJ+Jt2Ncz10/4CQSmZ3runaDZ+K0E/D7MXlitIs+/kk69O8PCmSH+wcfhDajcs09/A8/s6QBUd3unoaYfS3uPT2WI/9K2PGryLLo4lBbHitA3XNVh6RRxdx5aqSkZLtqjo0scSKc092xNngxORmghoj24zHhgx/j2gk9aNhJriEeH5IideYEfuSBaMcNxLAHGyy8yIIp6/WlP/nl1N1B93T17NSqxrGc8eRpZduP/X0tIXDRhmnSajsvjJfELajh+ITAzCIwnX2z9gnnqS9B+bTr+iU/12TK/mPAFQUddvOiyVOVB2ZTqxhgVdvoSRyQLahF36QAO4ENi/a/a00r0FhyE="
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyU0M8Mlg57OBD6Tyjyi5UAIt1JE6Zi3FW3xaAc762FzP1SCGEZnohLLut2Ney3Ot3x4u66NmRLemztOP7JstrXlukuB3pn+H0uECP4g/Briwy49jltywxiZltfjwKTXvEZ1pgwyesCTCuMUMy2gIffDdTEVwEGddYPxxufUoe5+I7TPIrj7rZOLa+juanCes+Riam4Qyr6qnzoCdNvcMTa6PRZQW296sXzo2fpGm+9iFUCg1+8lFwvQ+qroyfll4/51RaMggwi0mJyGYj/LZQrf1MzsGT0dghNqX3RLDLPDe1w5hO5JnOcCddrnNa4XzZA9U090YXgxtT8Cebuysv/kWne75dj8fO4r3QsnH48hK+RVIfTsiIrz3/WsVtpWW5qsDyM4g2KFulmcAjYVblLxpMKuokad1PiTCZl4cHeT0PyK7wXZjOqAtGgdelNJJvNjwRqWoX3GpLEMTv8Zg0O4qj8paiXcfGudZtjRyKK15mTr5lSnUSpg1NPX9O3SE="
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCc9NudgFNp2mnTHuzfeup5/+bTz5eQxtQmzE2ve8JSMBHvE+xmqRSJ3Z4lCYr/pxlFsEgoZXvpMuvsj+GEg49baCZxjhet1/E28xNZ4qN4Pl9mxMrkqYvwRwbjhsHXgmbRtvB7h2DnrWZaJoIoki0F7mIsXg7+qD+Pbx64NelEyXa7IHFtC76DBqIvcuBHeyaYhoUhoLFCFuUqvEPvOe1IQUE7o5NVIo+sTRJiz/Rz/XQxYnH6s3i2Jx+oUOO/qjRgjDoAXkNiPD3wtMglU4fWPkbBcGIxRZ83yfm+8wyx6AgZbAWz5Fq7Rwfzx5TZA0gnde+qs4nUqn6LeLjce6gp"
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXQ80BXfOMe+w22SuAMMf54xm4e2YpxGXqpk+HHQ5w99wnHKAib9a6vJ7qyIS80ym2OOtP2XwXN4tiwhy2DxdjBOce7Ogt6CFvHXTVmceYkhScHY9W6hpP0vtbkHaxGg6+8dC4OM6PNw/LkXl6FRpHPaLl2SEdd91qEzRugKQJXGZDqafLWLh+zEQqPW9JWKTW9tMhBUUYVlmzgxx9LQwQKjnHSFrPy7oGuFILhqUFMAYSsOfRu61WqMXPdkQ4vw/jQVy+vsCkpDbfqa2LqGz3oQhdT8IhZELkywlqLHIXNgexWQV6+Kr7NvN/bqzzhmP91Nimnyg+BzxG0GsBH7JmIedaFmOw82jNnz0Ut4sL+5noYGFBOjoWuti6vfsw8lW0R4B8zOkOvxpL0zgdzDpULWXBH1y0SmNdHM0DHsVeDetaYmlYTQybhFs9wcAaSwnQ8d/cseJUax1WQeRbj/60lEn7Xgm2E6WjP/4Cyn1ZjXtCu5XuLduYzsKQK1w/0E8="
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6dS74SphUIqJZI15KSYzlbTxPObho50+K/iWcmDvK3mgtr95Gdhh1gpCKiLzPOCeJJgaNv/Ti0zfO9MBw3PBDmS60CL5LT5k65Rlf5KEdXD0/Zdd1uGsLRBPJrSiyyiukC+gun4hzTmuxzGK3hEWqCgy1lC5nekWX8CsQvd+GBS8uKkX213Y87GMGZBPATwQ7YRmcaBdmNzj6EskORi/lVDPQ+xpmA1JUYeiwzUtBCGd0/P6jv4uOX6mGiM7w3y/tKm0C87duWFng2vL5SPLthe/Wl6U46Wed/T7KJGjFEMmXFiHMkYzTCT+QOwkPg84D16rkjCDQFTR14y/BceWCysc+/YO0yRq28fCOmt0fhmVrJrn38EP+Pm94U5b3qpcr5ucWVL69iKADIZuDYbSJedtHdmUd5LLEKiidMNONpi4jMH+pdFtAX1lfjm6UmPvG7pp5hJbUsBbKGlGSAv5Pt691aiv3oebqQdcSYbVl70pt0WcLNJdaEpe0LEDCnJU="
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDe78n6VCpHQZpadu2do7al7swA6Zvi63sVFVQUW4QbjV0cw48e1zAbHS3wCescc2AJosHExqOtAl+cTqwN7KxtL14sjiEkgpmR2ZblklQWl5bpYOcdphr9ROlxih3S1ma/TQQOrC+eJ0iZMdAcCxrsympgP9xDAJPGhBDpdEn44Mer+vOCsBZvGTRqP3DhTHMwf4x07bi6NvI4YLWteAaK/j/hu4pUS1OCW+e2E4k5pDuPmHYsq0pZ311bThDSfIQ3MlQEkJfhwMARN4rA0/RSuqPx13eRevOmn8fzt0KTUByXrEWNeC9SszcZsM7JqygdUaKY45543+odIrdu5w7bkBLibtXSczRZy1kEgDVFrvnGqGKh8e65BAzaGB+yIB+klg015OQTMIQIzqbG9EKxGeVO3EodSP58z3Fcnd14vBKKy6R5DM64ZntNiOEbOWkvr6oQe9Nu3ogHeARFLwQo8cq09QMc+D/tjEJZHOyuwGmisTCEEbPcOyPU6x+1H1E="
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzC/bqMF8yeV/sTXL2/c9bY4b1l8CEcOHoU4E2kFlbX+pU8nsLUJHkpjt7sXZrAfyVSgje3nBLjrbQzTYFnFVLFs7iUVDqSsV3g3JIxBISfVj8dFbrZ0egeSMolXe3fIBXhNnkERrgUKL3XdHBP+7L8jLKIfcMawv4AlzP52/WOgC9K3T7MVv+u/3dvy7rpPKwPi2KPZFWD2/M7yrMiAD81O8Kss2MH+iCzZdJMDKq/v5MCZD2xW7ks5NCJBI+gJs+9vaHR+xzBG9Iaz6PQ1oFhISTwoJElLZ7iT70no4MzZMDew866sWTV6WPZ8NEqXTZeYTwIyfKc358PX7SHuPFHzBb3ewy5J3sdvKVtlqlg9l8/JICJhWANs9v701dzawo3PgAZX9E3oeY3A4ldhzlZpGCZJAX7O9rBS8G1HL4O6lcTDNeSlDVD/hJJH9rltH5mMWbcVnrxp9v256+pY0akjSV0afiFw726L321Q2ZydIs8nv4B1vDTcEDA1LJSak="
      ];
      shell = pkgs.zsh;
    }
    (mkIf config.networking.networkmanager.enable {
      extraGroups = ["networkmanager"];
    })
  ];
}