# Minitalk-tests
A set of tests written to test the 42 school project Minitalk submission

## Installation
Clone the repository to your computer. Then, edit the `MT_DIR` variable in the `tests/auto.sh` file to point to the directory containing your Minitalk project files.

## Running the Tests
In the repository, type:
1. `make` or `make mandatory` to run tests on mandatory functions. The tester will build your Minitalk using the mandatory files.
2. `make bonus` to run tests on bonus functions. The tester will build your Minitalk using the bonus files.
3. `make all` to run tests on all functions. The tester will build your Minitalk using the mandatory and bonus files.

## Notes
1. This test checks for norminette error for all *.h and *.c files. If you have other non-Minitalk files with a .h or .c suffix, these files will also be checked.
2. This test does not check for leaks.
