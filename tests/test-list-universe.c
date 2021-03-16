/**
 * @file test-list-universe.c
 * @author Victor Colomb (vic.col@hotmail.fr)
 * @brief Test executable source code for a linked list implementation of Conway's game of life universe structure.
 * @date 2021-03-09
 */

#include <assert.h>
#include "list_universe.h"

linked_list list = NULL;
universe u;

/**
 * @brief Test of the `linked_list_insert` function
 *
 * The test will attemp to build the sorted list `(0,0) (1,0) (1,8) (2,7) (5,1) (5,3) (5,6)` with a random insert order. \n
 * Inserting at the beginning and the end of the list and attempting to insert a doublon will be tested.
 */
void test_linkedlist_insert()
{
  printf("  | testing linked_list_insert...");

  linked_list_insert(&list, 1, 0);
  linked_list_insert(&list, 5, 3);
  linked_list_insert(&list, 0, 0);
  linked_list_insert(&list, 2, 7);
  linked_list_insert(&list, 5, 6);
  linked_list_insert(&list, 5, 1);
  linked_list_insert(&list, 0, 0);
  linked_list_insert(&list, 1, 8);


  int row[] = {0, 1, 1, 2, 5, 5, 5};
  int column[] = {0, 0, 8, 7, 1, 3, 6};

  linked_list current_cell = list;
  for (int k = 0; k < 7; ++k)
  {
    assert(current_cell->row == row[k] && current_cell->column == column[k]);
    current_cell = current_cell->next;
  }

  assert(current_cell == NULL);
  printf(" OK!\n");
}

void test_linkedlist_delete()
{
  printf("  | testing linked_list_delete...\n");

  linked_list_delete(&list, 1, 8);
  linked_list_delete(&list, 0, 0);

  int row[] = {1, 2, 5, 5, 5};
  int column[] = {0, 7, 1, 3, 6};

  linked_list current_cell = list;
  for (int k = 0; k < 5; ++k)
  {
    assert(current_cell->row == row[k] && current_cell->column == column[k]);
    current_cell = current_cell->next;
  }

  assert(current_cell == NULL);

  linked_list_insert(&list, 0, 0);
  printf(" OK!\n");
}

/**
 * @brief Test of the `list_universe_get_cell` function
 *
 * The test will use the list generated by the `test_linkedlist_insert` function and test a series of cells.
 */
void test_universe_getcell()
{
  printf("  | testing list_universe_get_cell...");

  assert(list_universe_get_cell(u, 0, 0));
  assert(list_universe_get_cell(u, 2, 7));
  assert(list_universe_get_cell(u, 1, 0));
  assert(list_universe_get_cell(u, 5, 6));

  assert(!list_universe_get_cell(u, 0, 1));
  assert(!list_universe_get_cell(u, 4, 1));
  assert(!list_universe_get_cell(u, 8, 8));

  printf(" OK!\n");
}

/**
 * @brief Test of the `print_list_cells` function
 */
void test_universe_print()
{
  printf("  | testing print_list_cells...\n");
  print_list_cells(u);
  printf("  | OK!\n");
}

int main(void)
{
  printf("* Starting linked list implementation tests...\n");

  test_linkedlist_insert();
  test_linkedlist_delete();

  printf("  +-> OK!\n* Starting list universe structure tests...\n");

  u.width = 10;
  u.height = 6;
  u.step_nb = 10;
  u.cells = list;

  test_universe_getcell();
  test_universe_print();

  linked_list_free(list);
  printf("  +-> OK!\n");
}
