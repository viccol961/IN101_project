/**
 * @file naive_loader.c
 * @author Victor Colomb (vic.col@hotmail.fr)
 * @brief Source code for a naive implementation of Conway's game of life loader.
 * @date 2021-02-25
 */

#include "naive_loader.h"

universe naive_conway_load(char *data_filename)
{
  FILE *p_file;
  p_file = fopen(data_filename, "r");

  int width;
  int height;
  int nb_steps;

  int fscanf_result = fscanf(p_file, "%d %d", &width, &height);
  fscanf_result += fscanf(p_file, "%d\n", &nb_steps);

  if (fscanf_result != 3)
  {
    fprintf(stderr, "[!] File not properly formatted !\n");
    exit(EXIT_FAILURE);
  }

  char *cells = malloc((width * height + 1) * sizeof(char));
  cells[width * height] = '\0';
  char buffer[width + 2];

  for (int i = 0; i < height; ++i)
  {
    fgets(buffer, width + 2, p_file);

    for (int j = 0; j < width; ++j)
    {
      cells[i * width + j] = buffer[j];
    }
  }
  fclose(p_file);

  universe u = {width, height, nb_steps, cells};

  return u;
}
