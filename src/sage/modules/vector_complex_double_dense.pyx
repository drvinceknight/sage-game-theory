r"""
Dense complex double vectors using a NumPy backend.

EXAMPLES::

    sage: v = vector(CDF,[(1,-1), (2,pi), (3,5)])
    sage: v
    (1.0 - 1.0*I, 2.0 + 3.14159265359*I, 3.0 + 5.0*I)
    sage: type(v)
    <type 'sage.modules.vector_complex_double_dense.Vector_complex_double_dense'>
    sage: parent(v)
    Vector space of dimension 3 over Complex Double Field
    sage: v[0] = 5
    sage: v
    (5.0, 2.0 + 3.14159265359*I, 3.0 + 5.0*I)
    sage: loads(dumps(v)) == v
    True

TESTS::

    sage: v = vector(CDF, [2, 2])
    sage: v - v
    (0.0, 0.0)
    sage: (v - v).norm()
    0.0

AUTHORS:

    -- Jason Grout, Oct 2008: switch to NumPy backend, factored out
       Vector_double_dense class
"""

##############################################################################
#       Copyright (C) 2008 Jason Grout <jason-sage@creativetrax.com>
#  Distributed under the terms of the GNU General Public License (GPL)
#  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
##############################################################################
from sage.rings.complex_double import CDF

cimport numpy as cnumpy

numpy=None

cdef class Vector_complex_double_dense(vector_double_dense.Vector_double_dense):
    """
    Vectors over the Complex Double Field.  These are supposed to be
    fast vector operations using C doubles. Most operations are
    implemented using numpy which will call the underlying BLAS, if
    needed, on the system.

    EXAMPLES:
        sage: v = vector(CDF,[(1,-1), (2,pi), (3,5)])
        sage: v
        (1.0 - 1.0*I, 2.0 + 3.14159265359*I, 3.0 + 5.0*I)
        sage: v*v
        -21.8696044011 + 40.5663706144*I
    """
    def __cinit__(self, parent, entries, coerce=True, copy=True):
        global numpy
        if numpy is None:
            import numpy
        self._numpy_dtype = numpy.dtype('complex128')
        self._python_dtype = complex
        self._numpy_dtypeint = cnumpy.NPY_CDOUBLE
        # TODO: Make ComplexDoubleElement instead of CDF for speed
        self._sage_dtype = CDF
        self.__create_vector__()
        return

    def __reduce__(self):
        """
        Pickling

        EXAMPLE:
            sage: a = vector(CDF, range(9))
            sage: loads(dumps(a)) == a
            True
        """
        return (unpickle_v1, (self._parent, self.list(), self._degree, self._is_mutable))


# For backwards compatibility, we must keep the function unpickle_v0
def unpickle_v0(parent, entries, degree):
    """
    Create a complex double vector containing the entries.

    EXAMPLE:
        sage: v = vector(CDF, [1,2,3])
        sage: w = sage.modules.vector_complex_double_dense.unpickle_v0(v.parent(), list(v), v.degree())
        sage: v == w
        True
    """
    return unpickle_v1(parent, entries, degree)

def unpickle_v1(parent, entries, degree, is_mutable=None):
    """
    Create a complex double vector with the given parent, entries,
    degree, and mutability.

    EXAMPLE:
        sage: v = vector(CDF, [1,2,3])
        sage: w = sage.modules.vector_complex_double_dense.unpickle_v1(v.parent(), list(v), v.degree(), v.is_mutable())
        sage: v == w
        True
    """
    cdef Vector_complex_double_dense v = Vector_complex_double_dense(parent, entries)
    if is_mutable is not None:
        v._is_mutable = is_mutable
    return v


