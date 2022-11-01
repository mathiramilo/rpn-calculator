#define PORT_LOG_DEFAULT 100;
#define PORT_OUTPUT_DEFAULT 200;
#define PORT_INPUT 300;

// Representation of a stack
short stack[31];
short stack_amount = 0;

short port_log = PORT_LOG_DEFAULT;
short port_out = PORT_OUTPUT_DEFAULT;
short port_input = PORT_INPUT;

int main()
{
  short loop = 1;
  short command;
  while (loop)
  {
    out(port_log, 0);
    in(command, port_input);
    out(port_log, command);
    switch (command)
    {
    case 1:
      pushNumber();
      break;

    case 2:
      setOutputPort();
      break;

    case 3:
      setLogPort();
      break;

    case 4:
      top();
      break;

    case 5:
      dump();
      break;

    case 6:
      dup();
      break;

    case 7:
      swap();
      break;

    case 8:
      neg();
      break;

    case 9:
      callFact();
      break;

    case 10:
      sum();
      break;

    case 11:
      add();
      break;

    case 12:
      sub();
      break;

    case 13:
      mul();
      break;

    case 14:
      div();
      break;

    case 15:
      mod();
      break;

    case 16:
      and();
      break;

    case 17:
      or ();
      break;

    case 18:
      shiftLeft();
      break;

    case 19:
      shiftRight();
      break;

    case 254:
      clear();
      break;

    case 255:
      halt();
      break;

    default:
      // Invalid Command
      logCode(2);
      break;
    }
  }
}

// Push a number into the stack
void pushNumber()
{
  short num;
  in(num, port_input);
  out(port_log, num);
  if (stack_amount < 31)
  {
    push(num);
    stack_amount++;
    logCode(16);
  }
  else
  {
    logCode(4);
  }
  return;
}

// Set the port for the output
void setOutputPort()
{
  short num;
  in(num, port_input);
  port_out = num;
  out(port_log, num);
  logCode(16);
  return;
}

// Set the port for the log
void setLogPort()
{
  short num;
  in(num, port_input);
  port_log = num;
  out(port_log, num);
  logCode(16);
  return;
}

// Show the top of the stack in the output port
void top()
{
  if (stack_amount > 0)
  {
    short num;
    num = pop();
    push(num);
    out(port_out, num);
    logCode(16);
  }
  else
  {
    logCode(8);
  }
  return;
}

// Show the stack in the output port
void dump()
{
  if (stack_amount > 0)
  {
    short num;
    for (short i = 0; i < stack_amount; i++)
    {
      num = pop();
      push(num);
      out(port_out, num);
    }
    logCode(16);
  }
  else
  {
    logCode(8);
  }
  return;
}

// Duplicate the top of the stack
void dup()
{
  if (stack_amount < 31)
  {
    short num;
    num = pop();
    push(num);
    push(num);
    stack_amount++;
    logCode(16);
  }
  else
  {
    logCode(4);
  }
  return;
}

// Swap the top of the stack with the second element
void swap()
{
  if (stack_amount >= 2)
  {
    short num1, num2;
    num1 = pop();
    num2 = pop();
    push(num1);
    push(num2);
    logCode(16);
  }
  else if (stack_amount == 1)
  {
    pop();
    stack_amount--;
    logCode(8);
  }
  else
  {
    logCode(8);
  }
  return;
}

// Negate the top of the stack
void neg()
{
  if (stack_amount > 0)
  {
    short num;
    num = pop();
    push(-num);
    logCode(16);
  }
  else
  {
    logCode(8);
  }
  return;
}

// Call the factorial function with the top of the stack
void callFact()
{
  if (stack_amount > 0)
  {
    short num = pop();
    short result = fact(num);
    push(result);
    logCode(16);
  }
  else
  {
    logCode(8);
  }
}

// Recursive factorial
short fact(short num)
{
  if (num >= 1)
    return num * fact(num - 1);
  else
    return 1;
}

// Sum all elements of the stack
void sum()
{
  short num, sum = 0;
  for (short i = 0; i < stack_amount; i++)
  {
    num = pop();
    sum += num;
  }
  push(sum);
  stack_amount = 1;
  logCode(16);
  return;
}

// Add the top of the stack with the second element
void add()
{
  if (stack_amount >= 2)
  {
    short num1, num2;
    num1 = pop();
    num2 = pop();
    push(num2 + num1);
    stack_amount--;
    logCode(16);
  }
  else if (stack_amount == 1)
  {
    pop();
    stack_amount--;
    logCode(8);
  }
  else
  {
    logCode(8);
  }
  return;
}

// Substract the second element of the stack with the top
void sub()
{
  if (stack_amount >= 2)
  {
    short num1, num2;
    num1 = pop();
    num2 = pop();
    push(num2 - num1);
    stack_amount--;
    logCode(16);
  }
  else if (stack_amount == 1)
  {
    pop();
    stack_amount--;
    logCode(8);
  }
  else
  {
    logCode(8);
  }
  return;
}

// Multiply the second element of the stack with the top
void mul()
{
  if (stack_amount >= 2)
  {
    short num1, num2;
    num1 = pop();
    num2 = pop();
    push(num2 * num1);
    stack_amount--;
    logCode(16);
  }
  else if (stack_amount == 1)
  {
    pop();
    stack_amount--;
    logCode(8);
  }
  else
  {
    logCode(8);
  }
  return;
}

// Divide the second element of the stack with the top
void div()
{
  if (stack_amount >= 2)
  {
    short num1, num2;
    num1 = pop();
    num2 = pop();
    push(num2 / num1);
    stack_amount--;
    logCode(16);
  }
  else if (stack_amount == 1)
  {
    pop();
    stack_amount--;
    logCode(8);
  }
  else
  {
    logCode(8);
  }
  return;
}

// Mod the second element of the stack with the top
void mod()
{
  if (stack_amount >= 2)
  {
    short num1, num2;
    num1 = pop();
    num2 = pop();
    push(num2 % num1);
    stack_amount--;
    logCode(16);
  }
  else if (stack_amount == 1)
  {
    pop();
    stack_amount--;
    logCode(8);
  }
  else
  {
    logCode(8);
  }
  return;
}

// AND the second element of the stack with the top
void and ()
{
  if (stack_amount >= 2)
  {
    short num1, num2;
    num1 = pop();
    num2 = pop();
    push(num2 & num1);
    stack_amount--;
    logCode(16);
  }
  else if (stack_amount == 1)
  {
    pop();
    stack_amount--;
    logCode(8);
  }
  else
  {
    logCode(8);
  }
  return;
}

// OR the second element of the stack with the top
void or ()
{
  if (stack_amount >= 2)
  {
    short num1, num2;
    num1 = pop();
    num2 = pop();
    push(num2 | num1);
    stack_amount--;
    logCode(16);
  }
  else if (stack_amount == 1)
  {
    pop();
    stack_amount--;
    logCode(8);
  }
  else
  {
    logCode(8);
  }
  return;
}

// Shift left the second element of the stack with top
void shiftLeft()
{
  if (stack_amount >= 2)
  {
    short num1, num2;
    num1 = pop();
    num2 = pop();
    push(num2 << num1);
    stack_amount--;
    logCode(16);
  }
  else if (stack_amount == 1)
  {
    pop();
    stack_amount--;
    logCode(8);
  }
  else
  {
    logCode(8);
  }
  return;
}

// Shift right the second element of the stack with the top
void shiftRight()
{
  if (stack_amount >= 2)
  {
    short num1, num2;
    num1 = pop();
    num2 = pop();
    push(num2 >> num1);
    stack_amount--;
    logCode(16);
  }
  else if (stack_amount == 1)
  {
    pop();
    stack_amount--;
    logCode(8);
  }
  else
  {
    logCode(8);
  }
  return;
}

// Clear the stack
void clear()
{
  for (short i = 0; i < stack_amount; i++)
  {
    pop();
  }
  stack_amount = 0;
  logCode(16);
  return;
}

// Halt the program
void halt()
{
  logCode(16);
  while (1)
  {
  }
}

// Logs
void logCode(short num)
{
  out(port_log, num);
  return;
}
