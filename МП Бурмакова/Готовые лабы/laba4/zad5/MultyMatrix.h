#pragma once
#define OPTIMALM_PARM(x) ((int*)x)    // ��� ������������� 2������� �������

int OptimalM(int i, int j, int n, const int c[], int* s);
int OptimalMD(int n, const int c[], int* s);