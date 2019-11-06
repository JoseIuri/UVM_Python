#include <Python.h>
#include <stdio.h>

extern "C" int adder(int a, int b){
    Py_Initialize();
    PyObject* sysPath = PySys_GetObject((char*) "path");
    PyList_Append(sysPath, PyUnicode_DecodeFSDefault("../model/"));

    PyObject *pModule = NULL, *pFunc = NULL, *pArgs = NULL, *pValue = NULL;

    pModule = PyImport_ImportModule("adder");
    if (pModule == NULL) return -1;

    pFunc = PyObject_GetAttrString(pModule, "adder");
    if (pFunc == NULL) return -2;

    pArgs = Py_BuildValue("ii", a, b);
    if (pArgs == NULL) return -3;

    pValue = PyObject_Call(pFunc, pArgs, NULL);
    if (pValue == NULL) return -4;
    // printf("Result of call: %ld\n", PyLong_AsLong(pValue));

    Py_XDECREF(pValue);
    Py_XDECREF(pArgs);
    Py_XDECREF(pFunc);
    Py_XDECREF(pModule);

    int result = int(PyLong_AsLong(pValue));

    printf("%d\n", result);

    Py_Finalize();
    return result;
}