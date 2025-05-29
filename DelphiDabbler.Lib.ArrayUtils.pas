{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2025, Peter Johnson (www.delphidabbler.com).
 *
 * Defines an advanced record type that acts as a container for static class
 * methods that manipulate generic arrays.
}


unit DelphiDabbler.Lib.ArrayUtils;

// Delphi XE or later is required to compile
// For Delphi XE2 and later we use scoped unit names
{$UNDEF CanCompile}
{$UNDEF SupportsUnitScopeNames}
{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 24.0} // Delphi XE3 and later
    {$LEGACYIFEND ON}  // NOTE: this must come before all $IFEND directives
  {$IFEND}
  {$IF CompilerVersion >= 23.0} // Delphi XE2 and later
    {$DEFINE SupportsUnitScopeNames}
  {$IFEND}
  {$IF CompilerVersion >= 22.0} // Delphi XE and later
    {$DEFINE CanCompile}
  {$IFEND}
{$ENDIF}
{$IFNDEF CanCompile}
  {$MESSAGE FATAL 'Delphi XE or later required'}
{$ENDIF}

interface

uses
  {$IFDEF SupportsUnitScopeNames}
  System.SysUtils
  , System.Generics.Defaults
  {$ELSE}
  SysUtils
  , Generics.Defaults
  {$ENDIF}
  ;


type

  ///  <summary>Container for methods that assist with manipulation of generic
  ///  arrays.</summary>
  TArrayUtils = record
  strict private

    ///  <summary>Returns the minimum value of integers <c>A</c> and <c>B</c>.
    ///  </summary>
    class function IntMin(const A, B: Integer): Integer; static;

    ///  <summary>Returns the maximum value of integers <c>A</c> and <c>B</c>.
    ///  </summary>
    class function IntMax(const A, B: Integer): Integer; static;

    ///  <summary>Ensures that an integer value fits within a range.</summary>
    ///  <param name="AValue"><c>Integer</c> [in] Value to checked.</param>
    ///  <param name="ARangeLo"><c>Integer</c> [in] Lower bound of the range.
    ///  </param>
    ///  <param name="ARangeHi"><c>Integer</c> [in] Upper bound of the range.
    ///  </param>
    ///  <returns><c>Integer</c>. <c>AValue</c> if it falls within the range
    ///  bounds, <c>ARangeLo</c> if it is greater that <c>AValue</c> or
    ///  <c>ARangeHi</c> if it is less than <c>AValue</c>.</returns>
    class procedure ClampInRange(var AValue: Integer;
      const ARangeLo, ARangeHi: Integer); static;

    ///  <summary>Adjusts the starting and ending indexes of a contiguous range
    ///  of array elements to fit within the bounds of the array and outputs
    ///  the length of the range.</summary>
    ///  <param name="AArrayLength"><c>Integer</c> [in] The length of the array
    ///  in question.</param>
    ///  <param name="AStartIndex"><c>Integer</c> [in/out] The proposed starting
    ///  index of the range. Set to <c>0</c> if negative, otherwise left
    ///  unchanged.</param>
    ///  <param name="AEndIndex"><c>Integer</c> [in/out] The proposed ending
    ///  index of the range. Set to <c>AArrayLength - 1</c> if <c>AEndIndex</c>
    ///  &gt;= <c>AArrayLength</c>, otherwise left unchanged.</param>
    ///  <param name="ARangeLength"><c>Integer</c> [out] Set to the length of
    ///  the range defined by the adjusted values of <c>AStartIndex</c> and
    ///  <c>AEndIndex</c>. Will be <c>0</c> if <c>AEndIndex</c> &lt;
    ///  <c>AStartIndex</c>.</param>
    class procedure NormaliseArrayRange(const AArrayLength: Integer;
      var AStartIndex, AEndIndex: Integer; out ARangeLength: Integer); static;

    ///  <summary>Copies one array into another, starting at a given index.
    ///  </summary>
    ///  <param name="ADestArray"><c>TArray&gt;T&lt;</c> [in/out] The array
    ///  being copied into. Updated with the content of <c>ASourceArray</c>.
    ///  </param>
    ///  <param name="ADestArrayIdx"><c>Integer</c> [in/out] When called set to
    ///  the index in <c>ADestArray</c> where the first element of
    ///  <c>ASourceArray</c> is to be stored. Updated to the index in
    ///  <c>ADestArray</c> immediately after that where the last element of
    ///  <c>ASourceArray</c> was stored.</param>
    ///  <param name="ASourceArray"><c>array of T</c> [in] Array to be copied
    ///  into <c>ASourceArray</c>.</param>
    ///  <remarks>
    ///  <para><c>ADestArray</c> is assumed to be large enough to store the
    ///  whole of <c>ASourceArray</c>.</para>
    ///  <para>When the method returns <c>ADestArrayIdx</c> will store the index
    ///  where the first element of <c>ASourceArray</c> will be stored on any
    ///  subsequent call to this method.</para>
    ///  </remarks>
    class procedure CopyIntoArray<T>(var ADestArray: TArray<T>;
      var ADestArrayIdx: Integer; const ASourceArray: array of T); static;

    ///  <summary>Removes out of range and, optionally, duplicated values from
    ///  an array of array indices and returns the cleaned up array.</summary>
    ///  <param name="AIndices"><c>array of Integer</c> [in] Array of indices to
    ///  be cleaned up.</param>
    ///  <param name="AArrayLength"><c>Integer</c> [in] Length of the array to
    ///  which the indices relate. Any index &lt; <c>0</c> or &gt;=
    ///  <c>AArrayLength</c> is discarded.</param>
    ///  <param name="ADeDup"><c>Boolean</c> [in] Flag indicating whether to
    ///  remove any duplicated indices (<c>True</c>) or to leave duplicates in
    ///  place (<c>False</c>).</param>
    ///  <returns><c>TArray&lt;Integer&gt;</c>. The cleaned up array of indices.
    ///  </returns>
    class function CleanIndices(const AIndices: array of Integer;
      const AArrayLength: Integer; const ADeDup: Boolean): TArray<Integer>;
      static;

    ///  <summary>Moves a range of elements down a given array.</summary>
    ///  <param name="A"><c>TArray&lt;T&gt;</c> [in/out] Array containing the
    ///  elements to be moved. Updated in place.</param>
    ///  <param name="ARangeLo"><c>Integer</c> [in] Lowest index that the range
    ///  of elements is to be moved to.</param>
    ///  <param name="ARangeLo"><c>Integer</c> [in] Highest index that the range
    ///  of elements to be moved to.</param>
    ///  <param name="AOffset"><c>Integer</c> [in] Distance that the range of
    ///  elements will be moved down.</param>
    class procedure ShuffleDown<T>(var A: TArray<T>;
      const ARangeLo, ARangeHi, AOffset: Integer); static;

    ///  <summary>Moves a range of elements up a given array.</summary>
    ///  <param name="A"><c>TArray&lt;T&gt;</c> [in/out] Array containing the
    ///  elements to be moved. Updated in place.</param>
    ///  <param name="ARangeLo"><c>Integer</c> [in] Lowest index that the range
    ///  of elements is to be moved from.</param>
    ///  <param name="ARangeLo"><c>Integer</c> [in] Highest index that the range
    ///  of elements is to be moved from.</param>
    ///  <param name="AOffset"><c>Integer</c> [in] Distance that the range of
    ///  elements will be moved up.</param>
    class procedure ShuffleUp<T>(var A: TArray<T>;
      const ARangeLo, ARangeHi, AOffset: Integer); static;

  public
    type

      ///  <summary>Type of function that, when called for each element of an
      ///  array with element type <c>TIn</c>, maps that element's value to a
      ///  return value of type <c>TOut</c>.</summary>
      ///  <param name="AValue"><c>TIn</c> [in] Value to be transformed.</param>
      ///  <returns><c>TOut</c>. The transformed value.</returns>
      TTransformer<TIn,TOut> = reference to function (const AValue: TIn): TOut;

      ///  <summary>Type of function that, when called for each element of an
      ///  array with element type <c>TIn</c>, maps that element's value to a
      ///  return value of type <c>TOut</c>.</summary>
      ///  <param name="AValue"><c>TIn</c> [in] Value to be transformed.</param>
      ///  <param name="AIndex"><c>Integer</c> [in] Index of <c>AValue</c> in
      ///  the array.</param>
      ///  <param name="AArray"><c>array of TIn</c> [in] Array containing
      ///  <c>AValue</c>.</param>
      ///  <returns><c>TOut</c>. The transformed value.</returns>
      TTransformerEx<TIn,TOut> = reference to function (const AValue: TIn;
        const AIndex: Integer; const AArray: array of TIn): TOut;

      ///  <summary>Type of function that, when called repeatedly for each
      ///  element of an array, updates an accumulated value that has the same
      ///  type as the elements of the array.</summary>
      ///  <param name="AAccumulator"><c>T</c> [in] The value resulting from a
      ///  previous call to this function, or an initial value provided by the
      ///  caller.</param>
      ///  <param name="ACurrent"><c>T</c> [in] The value of the current array
      ///  element.</param>
      ///  <returns><c>T</c>. The new accumulated value.</returns>
      TReducer<T> = reference to function (const AAccumulator, ACurrent: T): T;

      ///  <summary>Type of function that, when called repeatedly for each
      ///  element of an array, updates an accumulated value that has the same
      ///  type as the elements of the array.</summary>
      ///  <param name="AAccumulator"><c>T</c> [in] The value resulting from a
      ///  previous call to this function, or an initial value provided by the
      ///  caller.</param>
      ///  <param name="ACurrent"><c>T</c> [in] The value of the current array
      ///  element.</param>
      ///  <param name="AIndex"><c>Integer</c> [in] Index of the current array
      ///  element within the array.</param>
      ///  <param name="AArray"><c>array of T</c> [in] Reference to the array
      ///  containing <c>ACurrent</c>.</param>
      ///  <returns><c>T</c>. The new accumulated value.</returns>
      TReducerEx<T> = reference to function (const AAccumulator, ACurrent: T;
        const AIndex: Integer; const AArray: array of T): T;

      ///  <summary>Type of function that, when called repeatedly for each
      ///  element of an array with element type <c>TIn</c>, updates an
      ///  accumulated value that has an optionally different type, <c>TOut</c>.
      ///  </summary>
      ///  <param name="AAccumulator"><c>TOut</c> [in] The value resulting from
      ///  a previous call to this function, or an initial value provided by the
      ///  caller.</param>
      ///  <param name="ACurrent"><c>TIn</c> [in] The value of the current array
      ///  element.</param>
      ///  <returns><c>TOut</c>. The new accumulated value.</returns>
      TReducer<TIn,TOut> = reference to function (const AAccumulator: TOut;
        const ACurrent: TIn): TOut;

      ///  <summary>Type of function that, when called repeatedly for each
      ///  element of an array with element type <c>TIn</c>, updates an
      ///  accumulated value that has an optionally different type, <c>TOut</c>.
      ///  </summary>
      ///  <param name="AAccumulator"><c>TOut</c> [in] The value resulting from
      ///  a previous call to this function, or an initial value provided by the
      ///  caller.</param>
      ///  <param name="ACurrent"><c>TIn</c> [in] The value of the current array
      ///  element.</param>
      ///  <param name="AIndex"><c>Integer</c> [in] Index of the current array
      ///  element within the array.</param>
      ///  <param name="AArray"><c>array of TIn</c> [in] Reference to the array
      ///  containing <c>ACurrent</c>.</param>
      ///  <returns><c>TOut</c>. The new accumulated value.</returns>
      TReducerEx<TIn,TOut> = reference to function (const AAccumulator: TOut;
        const ACurrent: TIn; const AIndex: Integer;
        const AArray: array of TIn): TOut;

      ///  <summary>Type of function that, when called for each element of an
      ///  array, checks whether the element conforms to a particular
      ///  constraint.</summary>
      ///  <param name="AElem"><c>T</c> [in] The element to be checked.</param>
      ///  <returns><c>Boolean</c>. <c>True</c> if <c>AElem</c> conforms to the
      ///  constraint or <c>False</c> if not.</returns>
      TConstraint<T> = reference to function (const AElem: T): Boolean;

      ///  <summary>Type of function that, when called for each element of an
      ///  array, checks whether the element conforms to a particular
      ///  constraint.</summary>
      ///  <param name="AElem"><c>T</c> [in] The element to be checked.</param>
      ///  <param name="AIndex"><c>Integer</c> [in] Index of <c>AElem</c> within
      ///  the array.</param>
      ///  <param name="AArray"><c>array of T</c> [in] Reference to the array
      ///  containing <c>AElem</c>.</param>
      ///  <returns><c>Boolean</c>. <c>True</c> if <c>AElem</c> conforms to the
      ///  constraint or <c>False</c> if not.</returns>
      TConstraintEx<T> = reference to function (const AElem: T;
        const AIndex: Integer; const AArray: array of T): Boolean;

      ///  <summary>Callback procedure that, when called for each element of an
      ///  array, performs a user defined action.</summary>
      ///  <param name="AElem"><c>T</c> [in] The current array element.</param>
      TCallback<T> = reference to procedure (const AElem: T);

      ///  <summary>Callback procedure that, when called for each element of an
      ///  array, performs a user defined action.</summary>
      ///  <param name="AElem"><c>T</c> [in] The current array element.</param>
      ///  <param name="AIndex"><c>Integer</c> [in] Index of <c>AElem</c> within
      ///  the array.</param>
      ///  <param name="AArray"><c>array of T</c> [in] Reference to the array
      ///  containing <c>AElem</c>.</param>
      TCallbackEx<T> = reference to procedure (const AElem: T;
        const AIndex: Integer; const AArray: array of T);

      ///  <summary>Reference to a function that, when called for each element
      ///  of an array, returns a deep copy of that element.</summary>
      ///  <param name="AElem"><c>T</c> [in] Element to be copied.</param>
      ///  <returns><c>T</c>. The required deep copy of <c>AElem</c>.</returns>
      TCloner<T> = reference to function (const AElem: T): T;

  public

    ///  <summary>Returns the first element of a non-empty array</summary>
    ///  <param name="A"><c>array of T</c> [in] Array on which to operate.
    ///  </param>
    ///  <returns><c>T</c>. The first element of <c>A</c>.</returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class function First<T>(const A: array of T): T;
      static;

    ///  <summary>Returns the last element of a non-empty array.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array on which to operate.
    ///  </param>
    ///  <returns><c>T</c>. The last element of <c>A</c>.</returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class function Last<T>(const A: array of T): T;
      static;

    ///  <summary>Returns a shallow copy of an array.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be copied.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. The required copy.</returns>
    class function Copy<T>(const A: array of T): TArray<T>;
      overload; static;

    ///  <summary>Returns a deep copy of an array.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be copied.</param>
    ///  <param name="ACloner"><c>TCloner&lt;T&gt;</c> [in] Function called for
    ///  each element of <c>A</c> that makes a deep copy of the element that is
    ///  then stored in the resulting array.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. The required copy.</returns>
    class function Copy<T>(const A: array of T;
      const ACloner: TCloner<T>): TArray<T>;
      overload; static;

    ///  <summary>Creates an array containing the concatenation of two arrays.
    ///  </summary>
    ///  <param name="A"><c>array of T</c> [in] First array copied to the
    ///  returned array.</param>
    ///  <param name="B"><c>array of T</c> [in] Second array copied to the
    ///  returned array.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. The required concatenation comprising
    ///  shallow copies of <c>A</c> and <c>B</c>.</returns>
    class function Concat<T>(const A, B: array of T): TArray<T>;
      static;

    ///  <summary>Returns an array comprising a shallow copy of elements of an
    ///  array that occur at specified indices in the array.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array from which the returned
    ///  elements are to be picked.</param>
    ///  <param name="AIndices"><c>array of Integer</c> [in] The indices in
    ///  <c>A</c> of the elements to be returned. If any index is out of range
    ///  in <c>A</c> then it is ignored.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. An array containing the chosen
    ///  elements. The array contains the elements in the order their indices
    ///  occur in <c>AIndices</c>. If any index is repeated in <c>AIndices</c>
    ///  then the associated element is repeated in the returned array.
    ///  </returns>
    class function Pick<T>(const A: array of T;
      const AIndices: array of Integer): TArray<T>;
      static;

    ///  <summary>Returns an array comprising a shallow copy of a contiguous
    ///  range of elements from an array.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array from which the slice is to
    ///  be copied.</param>
    ///  <param name="AStartIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the start of the slice.</param>
    ///  <param name="AEndIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the end of the slice.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. The required slice.</returns>
    ///  <remarks>
    ///  <para>If <c>AStartIndex</c> &lt;= <c>0</c> then the slice begins at the
    ///  first element of <c>A</c>.</para>
    ///  <para>If <c>AEndIndex</c> &gt;= <c>Length(A)</c> then the slice
    ///  continues to the end of <c>A</c>.</para>
    ///  <para>If <c>AEndIndex</c> is &lt; <c>AStartIndex</c> then an empty
    ///  array is returned.</para>
    ///  </remarks>
    class function Slice<T>(const A: array of T;
      AStartIndex, AEndIndex: Integer): TArray<T>;
      overload; static;

    ///  <summary>Returns an array comprising a shallow copy of a contiguous
    ///  range of elements at the end of an array.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array from which the slice is to
    ///  be copied.</param>
    ///  <param name="AStartIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the start of the slice.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. The required slice, which runs from
    ///  <c>AStartIndex</c> to the end of <c>A</c>.</returns>
    ///  <remarks>If <c>AStartIndex</c> &lt;= <c>0</c> then a copy of the whole
    ///  of <c>A</c> is returned.</remarks>
    class function Slice<T>(const A: array of T;
      AStartIndex: Integer): TArray<T>;
      overload; static;

    ///  <summary>Removes a contiguous range of elements from an array and
    ///  returns an array containing a shallow copy of the removed elements.
    ///  </summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array from which the range
    ///  of elements is to be removed. The modified array is passed out.</param>
    ///  <param name="AStartIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the start of the removed range of elements.</param>
    ///  <param name="AEndIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the end of the removed range of elements.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. Copy of the removed range of elements.
    ///  </returns>
    ///  <remarks>
    ///  <para>If <c>AStartIndex</c> &lt;= <c>0</c> then the chop begins at the
    ///  first element of <c>A</c>.</para>
    ///  <para>If <c>AEndIndex</c> &gt;= <c>Length(A)</c> then the chop
    ///  continues to the end of <c>A</c>.</para>
    ///  <para>If <c>AEndIndex</c> is &lt; <c>AStartIndex</c> then no change is
    ///  made to <c>A</c> and an empty array is returned.</para>
    ///  </remarks>
    class function Chop<T>(var A: TArray<T>;
      AStartIndex, AEndIndex: Integer): TArray<T>;
      overload; static;

    ///  <summary>Removes a contiguous range of elements from the end of an
    ///  array and returns an array containing a shallow copy of the removed
    ///  elements.</summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array from which the range
    ///  of elements is to be removed. The modified array is passed out.</param>
    ///  <param name="AStartIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the start of the removed range of elements.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. Copy of the removed range of elements,
    ///  which runs from <c>AStartIndex</c> to the end of <c>A</c>.</returns>
    ///  <remarks>If <c>AStartIndex</c> &lt;= <c>0</c> then all elements of
    ///  <c>A</c> are deleted and a copy of the whole of <c>A</c> is returned.
    ///  </remarks>
    class function Chop<T>(var A: TArray<T>; AStartIndex: Integer): TArray<T>;
      overload; static;

    ///  <summary>Finds the first index of an element of type <c>T</c> in a
    ///  given array that matches a given item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <param name="AEqualityComparer"><c>TEqualityComparison&lt;T&gt;</c>
    ///  [in] Reference to a function used to determine if two values of type
    ///  <c>T</c> are equal. Used to test <c>AItem</c> for equality with
    ///  elements of <c>A</c>.</param>
    ///  <returns><c>Integer</c>. The lowest index of an element of <c>A</c>
    ///  that tests equal to <c>AItem</c> or <c>-1</c> if <c>A</c> contains no
    ///  matching element.</returns>
    class function IndexOf<T>(const AItem: T; const A: array of T;
      const AEqualityComparer: TEqualityComparison<T>): Integer;
      overload; static;

    ///  <summary>Finds the first index of an element of type <c>T</c> in a
    ///  given array that matches a given item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <param name="AEqualityComparer"><c>IEqualityComparer&lt;T&gt;</c> [in]
    ///  Reference to an object that can be used to determine if two values of
    ///  type <c>T</c> are equal. Used to test <c>AItem</c> for equality with
    ///  elements of <c>A</c>.</param>
    ///  <returns><c>Integer</c>. The lowest index of an element of <c>A</c>
    ///  that tests equal to <c>AItem</c> or <c>-1</c> if <c>A</c> contains no
    ///  matching element.</returns>
    class function IndexOf<T>(const AItem: T; const A: array of T;
      const AEqualityComparer: IEqualityComparer<T>): Integer;
      overload; static;

    ///  <summary>Finds the first index of an element of type <c>T</c> in a
    ///  given array that matches a given item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <returns><c>Integer</c>. The lowest index of an element of <c>A</c>
    ///  that tests equal to <c>AItem</c> or <c>-1</c> if <c>A</c> contains no
    ///  matching element.</returns>
    ///  <remarks>The default equality comparer for type <c>T</c> is used to
    ///  test <c>AItem</c> for equality with the elements of <c>A</c>.</remarks>
    class function IndexOf<T>(const AItem: T; const A: array of T): Integer;
      overload; static;

    ///  <summary>Finds the last index of an element of type <c>T</c> in a
    ///  given array that matches a given item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <param name="AEqualityComparer"><c>TEqualityComparison&lt;T&gt;</c>
    ///  [in] Reference to a function used to determine if two values of type
    ///  <c>T</c> are equal. Used to test <c>AItem</c> for equality with
    ///  elements of <c>A</c>.</param>
    ///  <returns><c>Integer</c>. The greatest index of an element of <c>A</c>
    ///  that tests equal to <c>AItem</c> or <c>-1</c> if <c>A</c> contains no
    ///  matching element.</returns>
    class function LastIndexOf<T>(const AItem: T; const A: array of T;
      const AEqualityComparer: TEqualityComparison<T>): Integer;
      overload; static;

    ///  <summary>Finds the last index of an element of type <c>T</c> in a
    ///  given array that matches a given item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <param name="AEqualityComparer"><c>IEqualityComparer&lt;T&gt;</c> [in]
    ///  Reference to an object that can be used to determine if two values of
    ///  type <c>T</c> are equal. Used to test <c>AItem</c> for equality with
    ///  elements of <c>A</c>.</param>
    ///  <returns><c>Integer</c>. The greatest index of an element of <c>A</c>
    ///  that tests equal to <c>AItem</c> or <c>-1</c> if <c>A</c> contains no
    ///  matching element.</returns>
    class function LastIndexOf<T>(const AItem: T; const A: array of T;
      const AEqualityComparer: IEqualityComparer<T>): Integer;
      overload; static;

    ///  <summary>Finds the last index of an element of type <c>T</c> in a
    ///  given array that matches a given item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <returns><c>Integer</c>. The greatest index of an element of <c>A</c>
    ///  that tests equal to <c>AItem</c> or <c>-1</c> if <c>A</c> contains no
    ///  matching element.</returns>
    ///  <remarks>The default equality comparer for type <c>T</c> is used to
    ///  test <c>AItem</c> for equality with the elements of <c>A</c>.</remarks>
    class function LastIndexOf<T>(const AItem: T; const A: array of T): Integer;
      overload; static;

    ///  <summary>Finds the indices of all elements in an array that match a
    ///  given item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <param name="AEqualityComparer"><c>TEqualityComparison&lt;T&gt;</c>
    ///  [in] Reference to a function used to determine if two values of type
    ///  <c>T</c> are equal. Used to test <c>AItem</c> for equality with
    ///  elements of <c>A</c>.</param>
    ///  <returns><c>TArray&lt;Integer&gt;</c>. The indices of elements of
    ///  <c>A</c> that test equal to <c>AItem</c>. An empty array is returned if
    ///  <c>A</c> contains no matching element.</returns>
    class function IndicesOf<T>(const AItem: T; const A: array of T;
      const AEqualityComparer: TEqualityComparison<T>): TArray<Integer>;
      overload; static;

    ///  <summary>Finds the indices of all elements in an array that match a
    ///  given item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <param name="AEqualityComparer"><c>IEqualityComparer&lt;T&gt;</c> [in]
    ///  Reference to an object that can be used to determine if two values of
    ///  type <c>T</c> are equal. Used to test <c>AItem</c> for equality with
    ///  elements of <c>A</c>.</param>
    ///  <returns><c>TArray&lt;Integer&gt;</c>. The indices of elements of
    ///  <c>A</c> that test equal to <c>AItem</c>. An empty array is returned if
    ///  <c>A</c> contains no matching element.</returns>
    class function IndicesOf<T>(const AItem: T; const A: array of T;
      const AEqualityComparer: IEqualityComparer<T>): TArray<Integer>;
      overload; static;

    ///  <summary>Finds the indices of all elements in an array that match a
    ///  given item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <returns><c>TArray&lt;Integer&gt;</c>. The indices of elements of
    ///  <c>A</c> that test equal to <c>AItem</c>. An empty array is returned if
    ///  <c>A</c> contains no matching element.</returns>
    ///  <remarks>The default equality comparer for type <c>T</c> is used to
    ///  test <c>AItem</c> for equality with the elements of <c>A</c>.</remarks>
    class function IndicesOf<T>(const AItem: T;
      const A: array of T): TArray<Integer>;
      overload; static;

    ///  <summary>Checks if an array contains at least one element that matches
    ///  a given item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <param name="AEqualityComparer"><c>TEqualityComparison&lt;T&gt;</c>
    ///  [in] Reference to a function used to determine if two values of type
    ///  <c>T</c> are equal. Used to test <c>AItem</c> for equality with
    ///  elements of <c>A</c>.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if <c>A</c> contains at least one
    ///  element that tests equal to <c>AItem</c>, or <c>False</c> if not.
    ///  </returns>
    class function Contains<T>(const AItem: T; const A: array of T;
      const AEqualityComparer: TEqualityComparison<T>): Boolean;
      overload; static;

    ///  <summary>Checks if an array contains at least one element that matches
    ///  a given item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <param name="AEqualityComparer"><c>IEqualityComparer&lt;T&gt;</c> [in]
    ///  Reference to an object that can be used to determine if two values of
    ///  type <c>T</c> are equal. Used to test <c>AItem</c> for equality with
    ///  elements of <c>A</c>.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if <c>A</c> contains at least one
    ///  element that tests equal to <c>AItem</c>, or <c>False</c> if not.
    ///  </returns>
    class function Contains<T>(const AItem: T; const A: array of T;
      const AEqualityComparer: IEqualityComparer<T>): Boolean;
      overload; static;

    ///  <summary>Checks if an array contains at least one element that matches
    ///  a given item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if <c>A</c> contains at least one
    ///  element that tests equal to <c>AItem</c>, or <c>False</c> if not.
    ///  </returns>
    ///  <remarks>The default equality comparer for type <c>T</c> is used to
    ///  test <c>AItem</c> for equality with the elements of <c>A</c>.</remarks>
    class function Contains<T>(const AItem: T; const A: array of T): Boolean;
      overload; static;

    ///  <summary>Counts the number of elements in an array that match a given
    ///  item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <param name="AEqualityComparer"><c>TEqualityComparison&lt;T&gt;</c>
    ///  [in] Reference to a function used to determine if two values of type
    ///  <c>T</c> are equal. Used to test <c>AItem</c> for equality with
    ///  elements of <c>A</c>.</param>
    ///  <returns><c>Integer</c>. The number of elements of <c>A</c> that test
    ///  equal to <c>AItem</c>. <c>0</c> is returned if there are no such
    ///  elements.</returns>
    class function OccurrencesOf<T>(const AItem: T; const A: array of T;
      const AEqualityComparer: TEqualityComparison<T>): Integer;
      overload; static;

    ///  <summary>Counts the number of elements in an array that match a given
    ///  item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <param name="AEqualityComparer"><c>IEqualityComparer&lt;T&gt;</c> [in]
    ///  Reference to an object that can be used to determine if two values of
    ///  type <c>T</c> are equal. Used to test <c>AItem</c> for equality with
    ///  elements of <c>A</c>.</param>
    ///  <returns><c>Integer</c>. The number of elements of <c>A</c> that test
    ///  equal to <c>AItem</c>. <c>0</c> is returned if there are no such
    ///  elements.</returns>
    class function OccurrencesOf<T>(const AItem: T; const A: array of T;
      const AEqualityComparer: IEqualityComparer<T>): Integer;
      overload; static;

    ///  <summary>Counts the number of elements in an array that match a given
    ///  item.</summary>
    ///  <param name="AItem"><c>T</c> [in] Item to search for in the array.
    ///  </param>
    ///  <param name="A"><c>array of T</c> [in] Array to be searched.</param>
    ///  <returns><c>Integer</c>. The number of elements of <c>A</c> that test
    ///  equal to <c>AItem</c>. <c>0</c> is returned if there are no such
    ///  elements.</returns>
    ///  <remarks>The default equality comparer for type <c>T</c> is used to
    ///  test <c>AItem</c> for equality with the elements of <c>A</c>.</remarks>
    class function OccurrencesOf<T>(const AItem: T;
      const A: array of T): Integer;
      overload; static;

    ///  <summary>Attempts to find the first element of an array for which a
    ///  given constraint function returns <c>True</c>. Returns a <c>Boolean</c>
    ///  that indicates success or failure.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraint&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element. Returns <c>True</c> if the element
    ///  meets the required criteria or <c>False</c> otherwise.</param>
    ///  <param name="AItem"><c>T</c> [out] Set to the first element of <c>A</c>
    ///  for which <c>AConstraint</c> returns <c>True</c>. Undefined if no such
    ///  element is found.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if an element for which
    ///  <c>AConstraint</c> returns <c>True</c> is found, <c>False</c>
    ///  otherwise.</returns>
    class function TryFind<T>(const A: array of T;
      const AConstraint: TConstraint<T>; out AItem: T): Boolean;
      overload; static;

    ///  <summary>Attempts to find the first element of an array for which a
    ///  given constraint function returns <c>True</c>. Returns a <c>Boolean</c>
    ///  that indicates success or failure.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraintEx&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element, the index of the current element in
    ///  <c>A</c> and a reference to <c>A</c>. Returns <c>True</c> if the
    ///  element meets the required criteria or <c>False</c> otherwise.</param>
    ///  <param name="AItem"><c>T</c> [out] Set to the first element of <c>A</c>
    ///  for which <c>AConstraint</c> returns <c>True</c>. Undefined if no such
    ///  element is found.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if an element for which
    ///  <c>AConstraint</c> returns <c>True</c> is found, <c>False</c>
    ///  otherwise.</returns>
    class function TryFind<T>(const A: array of T;
      const AConstraint: TConstraintEx<T>; out AItem: T): Boolean;
      overload; static;

    ///  <summary>Attempts to find the last element of an array for which a
    ///  given constraint function returns <c>True</c>. Returns a <c>Boolean</c>
    ///  that indicates success or failure.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraint&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element. Returns <c>True</c> if the element
    ///  meets the required criteria or <c>False</c> otherwise.</param>
    ///  <param name="AItem"><c>T</c> [out] Set to the last element of <c>A</c>
    ///  for which <c>AConstraint</c> returns <c>True</c>. Undefined if no such
    ///  element is found.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if an element for which
    ///  <c>AConstraint</c> returns <c>True</c> is found, <c>False</c>
    ///  otherwise.</returns>
    class function TryFindLast<T>(const A: array of T;
      const AConstraint: TConstraint<T>; out AItem: T): Boolean;
      overload; static;

    ///  <summary>Attempts to find the last element of an array for which a
    ///  given constraint function returns <c>True</c>. Returns a <c>Boolean</c>
    ///  that indicates success or failure.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraintEx&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element, the index of the current element in
    ///  <c>A</c> and a reference to <c>A</c>. Returns <c>True</c> if the
    ///  element meets the required criteria or <c>False</c> otherwise.</param>
    ///  <param name="AItem"><c>T</c> [out] Set to the last element of <c>A</c>
    ///  for which <c>AConstraint</c> returns <c>True</c>. Undefined if no such
    ///  element is found.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if an element for which
    ///  <c>AConstraint</c> returns <c>True</c> is found, <c>False</c>
    ///  otherwise.</returns>
    class function TryFindLast<T>(const A: array of T;
      const AConstraint: TConstraintEx<T>; out AItem: T): Boolean;
      overload; static;

    ///  <summary>Finds the first element of an array for which a given
    ///  constraint function returns <c>True</c>, or chooses a default value if
    ///  no such element exists.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraint&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element. Returns <c>True</c> if the element
    ///  meets the required criteria or <c>False</c> otherwise.</param>
    ///  <param name="ADefault"><c>T</c> [in] Default value to be returned if
    ///  <c>AConstraint</c> does not return <c>True</c> for any element of
    ///  <c>A</c>.</param>
    ///  <returns><c>T</c>. The value of the first element of <c>A</c> for which
    ///  <c>AConstraint</c> returns <c>True</c>, or <c>ADefault</c> if there is
    ///  no such element.</returns>
    class function FindDef<T>(const A: array of T;
      const AConstraint: TConstraint<T>; const ADefault: T): T;
      overload; static;

    ///  <summary>Finds the first element of an array for which a given
    ///  constraint function returns <c>True</c>, or chooses a default value if
    ///  no such element exists.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraintEx&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element, the index of the current element in
    ///  <c>A</c> and a reference to <c>A</c>. Returns <c>True</c> if the
    ///  element meets the required criteria or <c>False</c> otherwise.</param>
    ///  <param name="ADefault"><c>T</c> [in] Default value to be returned if
    ///  <c>AConstraint</c> does not return <c>True</c> for any element of
    ///  <c>A</c>.</param>
    ///  <returns><c>T</c>. The value of the first element of <c>A</c> for which
    ///  <c>AConstraint</c> returns <c>True</c>, or <c>ADefault</c> if there is
    ///  no such element.</returns>
    class function FindDef<T>(const A: array of T;
      const AConstraint: TConstraintEx<T>; const ADefault: T): T;
      overload; static;

    ///  <summary>Finds the last element of an array for which a given
    ///  constraint function returns <c>True</c>, or chooses a default value if
    ///  no such element exists.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraint&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element. Returns <c>True</c> if the element
    ///  meets the required criteria or <c>False</c> otherwise.</param>
    ///  <param name="ADefault"><c>T</c> [in] Default value to be returned if
    ///  <c>AConstraint</c> does not return <c>True</c> for any element of
    ///  <c>A</c>.</param>
    ///  <returns><c>T</c>. The value of the last element of <c>A</c> for which
    ///  <c>AConstraint</c> returns <c>True</c>, or <c>ADefault</c> if there is
    ///  no such element.</returns>
    class function FindLastDef<T>(const A: array of T;
      const AConstraint: TConstraint<T>; const ADefault: T): T;
      overload; static;

    ///  <summary>Finds the last element of an array for which a given
    ///  constraint function returns <c>True</c>, or chooses a default value if
    ///  no such element exists.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraintEx&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element, the index of the current element in
    ///  <c>A</c> and a reference to <c>A</c>. Returns <c>True</c> if the
    ///  element meets the required criteria or <c>False</c> otherwise.</param>
    ///  <param name="ADefault"><c>T</c> [in] Default value to be returned if
    ///  <c>AConstraint</c> does not return <c>True</c> for any element of
    ///  <c>A</c>.</param>
    ///  <returns><c>T</c>. The value of the last element of <c>A</c> for which
    ///  <c>AConstraint</c> returns <c>True</c>, or <c>ADefault</c> if there is
    ///  no such element.</returns>
    class function FindLastDef<T>(const A: array of T;
      const AConstraint: TConstraintEx<T>; const ADefault: T): T;
      overload; static;

    ///  <summary>Finds all the elements of an array for which a given
    ///  constraint function returns <c>True</c>.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraint&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element. Returns <c>True</c> if the element
    ///  meets the required criteria or <c>False</c> otherwise.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. Array of elements of <c>A</c> for
    ///  which <c>AConstraint</c> returns <c>True</c>. Will be empty if no such
    ///  elements exist.</returns>
    class function FindAll<T>(const A: array of T;
      const AConstraint: TConstraint<T>): TArray<T>;
      overload; static;

    ///  <summary>Finds all the elements of an array for which a given
    ///  constraint function returns <c>True</c>.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraintEx&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element, the index of the current element in
    ///  <c>A</c> and a reference to <c>A</c>. Returns <c>True</c> if the
    ///  element meets the required criteria or <c>False</c> otherwise.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. Array of elements of <c>A</c> for
    ///  which <c>AConstraint</c> returns <c>True</c>. Will be empty if no such
    ///  elements exist.</returns>
    class function FindAll<T>(const A: array of T;
      const AConstraint: TConstraintEx<T>): TArray<T>;
      overload; static;

    ///  <summary>Finds the index of the first element of an array for which a
    ///  given constraint function returns <c>True</c>.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraint&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element. Returns <c>True</c> if the element
    ///  meets the required criteria or <c>False</c> otherwise.</param>
    ///  <returns><c>Integer</c>. The index of the first element of <c>A</c> for
    ///  which <c>AConstraint</c> returns <c>True</c> or <c>-1</c> if <c>A</c>
    ///  contains no matching element.</returns>
    class function FindIndex<T>(const A: array of T;
      const AConstraint: TConstraint<T>): Integer;
      overload; static;

    ///  <summary>Finds the index of the first element of an array for which a
    ///  given constraint function returns <c>True</c>.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraintEx&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element, the index of the current element in
    ///  <c>A</c> and a reference to <c>A</c>. Returns <c>True</c> if the
    ///  element meets the required criteria or <c>False</c> otherwise.</param>
    ///  <returns><c>Integer</c>. The index of the first element of <c>A</c> for
    ///  which <c>AConstraint</c> returns <c>True</c> or <c>-1</c> if <c>A</c>
    ///  contains no matching element.</returns>
    class function FindIndex<T>(const A: array of T;
      const AConstraint: TConstraintEx<T>): Integer;
      overload; static;

    ///  <summary>Finds the index of the last element of an array for which a
    ///  given constraint function returns <c>True</c>.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraint&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element. Returns <c>True</c> if the element
    ///  meets the required criteria or <c>False</c> otherwise.</param>
    ///  <returns><c>Integer</c>. The index of the last element of <c>A</c> for
    ///  which <c>AConstraint</c> returns <c>True</c> or <c>-1</c> if <c>A</c>
    ///  contains no matching element.</returns>
    class function FindLastIndex<T>(const A: array of T;
      const AConstraint: TConstraint<T>): Integer;
      overload; static;

    ///  <summary>Finds the index of the last element of an array for which a
    ///  given constraint function returns <c>True</c>.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraintEx&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element, the index of the current element in
    ///  <c>A</c> and a reference to <c>A</c>. Returns <c>True</c> if the
    ///  element meets the required criteria or <c>False</c> otherwise.</param>
    ///  <returns><c>Integer</c>. The index of the last element of <c>A</c> for
    ///  which <c>AConstraint</c> returns <c>True</c> or <c>-1</c> if <c>A</c>
    ///  contains no matching element.</returns>
    class function FindLastIndex<T>(const A: array of T;
      const AConstraint: TConstraintEx<T>): Integer;
      overload; static;

    ///  <summary>Finds the indices of all the elements of an array for which a
    ///  given constraint function returns <c>True</c>.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraint&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element. Returns <c>True</c> if the element
    ///  meets the required criteria or <c>False</c> otherwise.</param>
    ///  <returns><c>TArray&lt;Integer&gt;</c>. Array of indices of the elements
    ///  of <c>A</c> for which <c>AConstraint</c> returns <c>True</c>. Will be
    ///  empty if no such elements exist.</returns>
    class function FindAllIndices<T>(const A: array of T;
      const AConstraint: TConstraint<T>): TArray<Integer>;
      overload; static;

    ///  <summary>Finds the indices of all the elements of an array for which a
    ///  given constraint function returns <c>True</c>.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraintEx&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element, the index of the current element in
    ///  <c>A</c> and a reference to <c>A</c>. Returns <c>True</c> if the
    ///  element meets the required criteria or <c>False</c> otherwise.</param>
    ///  <returns><c>TArray&lt;Integer&gt;</c>. Array of indices of the elements
    ///  of <c>A</c> for which <c>AConstraint</c> returns <c>True</c>. Will be
    ///  empty if no such elements exist.</returns>
    class function FindAllIndices<T>(const A: array of T;
      const AConstraint: TConstraintEx<T>): TArray<Integer>;
      overload; static;

    ///  <summary>Checks if two arrays have the same contents, in the same
    ///  order.</summary>
    ///  <param name="ALeft"><c>array of T</c> [in] The first array to be
    ///  checked.</param>
    ///  <param name="ARight"><c>array of T</c> [in] The second array to be
    ///  checked.</param>
    ///  <param name="AEqualityComparer"><c>TEqualityComparison&lt;T&gt;</c>
    ///  [in] Reference to a function used to determine if two values of type
    ///  <c>T</c> are equal. Used to test elements of <c>ALeft</c> and
    ///  <c>ARight</c> for equality.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if the arrays are equal,
    ///  <c>False</c> if not.</returns>
    class function Equal<T>(const ALeft, ARight: array of T;
      const AEqualityComparer: TEqualityComparison<T>): Boolean;
      overload; static;

    ///  <summary>Checks if two arrays have the same contents, in the same
    ///  order.</summary>
    ///  <param name="ALeft"><c>array of T</c> [in] The first array to be
    ///  checked.</param>
    ///  <param name="ARight"><c>array of T</c> [in] The second array to be
    ///  checked.</param>
    ///  <param name="AEqualityComparer"><c>IEqualityComparer&lt;T&gt;</c> [in]
    ///  Reference to an object that can be used to determine if two values of
    ///  type <c>T</c> are equal. Used to test elements of <c>ALeft</c> and
    ///  <c>ARight</c> for equality.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if the arrays are equal,
    ///  <c>False</c> if not.</returns>
    class function Equal<T>(const ALeft, ARight: array of T;
      const AEqualityComparer: IEqualityComparer<T>): Boolean;
      overload; static;

    ///  <summary>Checks if two arrays have the same contents, in the same
    ///  order.</summary>
    ///  <param name="ALeft"><c>array of T</c> [in] The first array to be
    ///  checked.</param>
    ///  <param name="ARight"><c>array of T</c> [in] The second array to be
    ///  checked.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if the arrays are equal,
    ///  <c>False</c> if not.</returns>
    ///  <remarks>The default equality comparer for type <c>T</c> is used to
    ///  test the elements and <c>ALeft</c> and <c>ARight</c> for equality.
    ///  </remarks>
    class function Equal<T>(const ALeft, ARight: array of T): Boolean;
      overload; static;

    ///  <summary>Checks if a given number of elements at the start of two
    ///  arrays are equal.</summary>
    ///  <param name="ALeft"><c>array of T</c> [in] The first array to be
    ///  checked.</param>
    ///  <param name="ARight"><c>array of T</c> [in] The second array to be
    ///  checked.</param>
    ///  <param name="ACount"><c>Integer</c> [in] The number of elements at the
    ///  start of the arrays that must be equal. Must be &gt;= <c>1</c>.</param>
    ///  <param name="AEqualityComparer"><c>TEqualityComparison&lt;T&gt;</c>
    ///  [in] Reference to a function used to determine if two values of type
    ///  <c>T</c> are equal. Used to test elements of <c>ALeft</c> and
    ///  <c>ARight</c> for equality.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if the required number of elements
    ///  are equal or <c>False</c> if the elements are not equal or if either
    ///  array has fewer than <c>ACount</c> elements.</returns>
    ///  <exception><c>EAssertionFailed</c> is raised if <c>ACount</c> is not
    ///  positive.</exception>
    class function EqualStart<T>(const ALeft, ARight: array of T;
      const ACount: Integer; const AEqualityComparer: TEqualityComparison<T>):
      Boolean;
      overload; static;

    ///  <summary>Checks if a given number of elements at the start of two
    ///  arrays are equal.</summary>
    ///  <param name="ALeft"><c>array of T</c> [in] The first array to be
    ///  checked.</param>
    ///  <param name="ARight"><c>array of T</c> [in] The second array to be
    ///  checked.</param>
    ///  <param name="ACount"><c>Integer</c> [in] The number of elements at the
    ///  start of the arrays that must be equal. Must be &gt;= <c>1</c>.</param>
    ///  <param name="AEqualityComparer"><c>IEqualityComparer&lt;T&gt;</c> [in]
    ///  Reference to an object that can be used to determine if two values of
    ///  type <c>T</c> are equal. Used to test elements of <c>ALeft</c> and
    ///  <c>ARight</c> for equality.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if the required number of elements
    ///  are equal or <c>False</c> if the elements are not equal or if either
    ///  array has fewer than <c>ACount</c> elements.</returns>
    ///  <exception><c>EAssertionFailed</c> is raised if <c>ACount</c> is not
    ///  positive.</exception>
    class function EqualStart<T>(const ALeft, ARight: array of T;
      const ACount: Integer; const AEqualityComparer: IEqualityComparer<T>):
      Boolean;
      overload; static;

    ///  <summary>Checks if a given number of elements at the start of two
    ///  arrays are equal.</summary>
    ///  <param name="ALeft"><c>array of T</c> [in] The first array to be
    ///  checked.</param>
    ///  <param name="ARight"><c>array of T</c> [in] The second array to be
    ///  checked.</param>
    ///  <param name="ACount"><c>Integer</c> [in] The number of elements at the
    ///  start of the arrays that must be equal. Must be &gt;= <c>1</c>.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if the required number of elements
    ///  are equal or <c>False</c> if the elements are not equal or if either
    ///  array has fewer than <c>ACount</c> elements.</returns>
    ///  <exception><c>EAssertionFailed</c> is raised if <c>ACount</c> is not
    ///  positive.</exception>
    ///  <remarks>The default equality comparer for type <c>T</c> is used to
    ///  test the elements and <c>ALeft</c> and <c>ARight</c> for equality.
    ///  </remarks>
    class function EqualStart<T>(const ALeft, ARight: array of T;
      const ACount: Integer): Boolean;
      overload; static;

    ///  <summary>Compares two arrays.</summary>
    ///  <param name="ALeft"><c>array of T</c> [in] The first array to be
    ///  checked.</param>
    ///  <param name="ARight"><c>array of T</c> [in] The second array to be
    ///  checked.</param>
    ///  <param name="AComparer"><c>TComparison&lt;T&gt;</c> [in] Reference to a
    ///  function that compares two elements of type <c>T</c>. Used to compare
    ///  the elements of <c>ALeft</c> and <c>ARight</c>.</param>
    ///  <returns><c>Integer</c>. Zero if the two arrays are equal, -ve if
    ///  <c>ALeft</c> &lt; <c>ARight</c> and +ve if <c>ALeft</c> &gt;
    ///  <c>ARight</c>.</returns>
    class function Compare<T>(const ALeft, ARight: array of T;
      const AComparer: TComparison<T>): Integer;
      overload; static;

    ///  <summary>Compares two arrays.</summary>
    ///  <param name="ALeft"><c>array of T</c> [in] The first array to be
    ///  checked.</param>
    ///  <param name="ARight"><c>array of T</c> [in] The second array to be
    ///  checked.</param>
    ///  <param name="AComparer"><c>IComparer&lt;T&gt;</c> [in] Reference to an
    ///  object that can be used to compare two elements of type <c>T</c>. Used
    ///  to compare the elements of <c>ALeft</c> and <c>ARight</c>.</param>
    ///  <returns><c>Integer</c>. Zero if the two arrays are equal, -ve if
    ///  <c>ALeft</c> &lt; <c>ARight</c> and +ve if <c>ALeft</c> &gt;
    ///  <c>ARight</c>.</returns>
    class function Compare<T>(const ALeft, ARight: array of T;
      const AComparer: IComparer<T>): Integer;
      overload; static;

    ///  <summary>Compares two arrays.</summary>
    ///  <param name="ALeft"><c>array of T</c> [in] The first array to be
    ///  checked.</param>
    ///  <param name="ARight"><c>array of T</c> [in] The second array to be
    ///  checked.</param>
    ///  <returns><c>Integer</c>. Zero if the two arrays are equal, -ve if
    ///  <c>ALeft</c> &lt; <c>ARight</c> and +ve if <c>ALeft</c> &gt;
    ///  <c>ARight</c>.</returns>
    ///  <remarks>The default comparer for type <c>T</c> is used to compare the
    ///  array elements.</remarks>
    class function Compare<T>(const ALeft, ARight: array of T): Integer;
      overload; static;

    ///  <summary>Reverses the order of the elements of the given array.
    ///  </summary>
    ///  <param name="A"><c>array of T</c> [in/out] The array to be reversed is
    ///  passed in and the reversed array is passed out.</param>
    class procedure Reverse<T>(var A: array of T);
      static;

    ///  <summary>Returns a copy of an array with the order of its elements
    ///  reversed.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be reversed.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. The reversed copy of the array.
    ///  </returns>
    ///  <remarks>Array <c>A</c> is not modified.</remarks>
    class function CopyReversed<T>(const A: array of T): TArray<T>;
      static;

    ///  <summary>Finds the maximum value of a non empty array.</summary>
    ///  <param name="A"><c>array of T</c> [in] The array to be examined.
    ///  </param>
    ///  <param name="AComparer"><c>TComparison&lt;T&gt;</c> [in] Reference to a
    ///  function that compares two elements of type <c>T</c>. Used to determine
    ///  the ordering of the elements of <c>A</c>.</param>
    ///  <returns><c>T</c>. The value of the largest element of <c>A</c>.
    ///  </returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class function Max<T>(const A: array of T;
      const AComparer: TComparison<T>): T;
      overload; static;

    ///  <summary>Finds the maximum value of a non empty array.</summary>
    ///  <param name="A"><c>array of T</c> [in] The array to be examined.
    ///  </param>
    ///  <param name="AComparer"><c>IComparer&lt;T&gt;</c> [in] Reference to an
    ///  object that can be used to compare two elements of type <c>T</c>. Used
    ///  to compare the elements of <c>A</c>. Used to determine the ordering of
    ///  the elements of <c>A</c>.</param>
    ///  <returns><c>T</c>. The value of the largest element of <c>A</c>.
    ///  </returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class function Max<T>(const A: array of T;
      const AComparer: IComparer<T> ): T;
      overload; static;

    ///  <summary>Finds the maximum value of a non empty array.</summary>
    ///  <param name="A"><c>array of T</c> [in] The array to be examined.
    ///  </param>
    ///  <returns><c>T</c>. The value of the largest element of <c>A</c>.
    ///  </returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    ///  <remarks>The default comparer for type <c>T</c> is used to determine
    ///  the ordering of the elements of <c>A</c>.</remarks>
    class function Max<T>(const A: array of T): T;
      overload; static;

    ///  <summary>Finds the minimum value of a non empty array.</summary>
    ///  <param name="A"><c>array of T</c> [in] The array to be examined.
    ///  </param>
    ///  <param name="AComparer"><c>TComparison&lt;T&gt;</c> [in] Reference to a
    ///  function that compares two elements of type <c>T</c>. Used to determine
    ///  the ordering of the elements of <c>A</c>.</param>
    ///  <returns><c>T</c>. The value of the smallest element of <c>A</c>.
    ///  </returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class function Min<T>(const A: array of T;
      const AComparer: TComparison<T>): T;
      overload; static;

    ///  <summary>Finds the minimum value of a non empty array.</summary>
    ///  <param name="A"><c>array of T</c> [in] The array to be examined.
    ///  </param>
    ///  <param name="AComparer"><c>IComparer&lt;T&gt;</c> [in] Reference to an
    ///  object that can be used to compare two elements of type <c>T</c>. Used
    ///  to determine the ordering of the elements of <c>A</c>.</param>
    ///  <returns><c>T</c>. The value of the smallest element of <c>A</c>.
    ///  </returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class function Min<T>(const A: array of T;
      const AComparer: IComparer<T>): T;
      overload; static;

    ///  <summary>Finds the minimum value of a non empty array.</summary>
    ///  <param name="A"><c>array of T</c> [in] The array to be examined.
    ///  </param>
    ///  <returns><c>T</c>. The value of the smallest element of <c>A</c>.
    ///  </returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    ///  <remarks>The default comparer for type <c>T</c> is used to determine
    ///  the ordering of the elements of <c>A</c>.</remarks>
    class function Min<T>(const A: array of T): T;
      overload; static;

    ///  <summary>Finds the minimum and maximum values of a non empty array.
    ///  </summary>
    ///  <param name="A"><c>array of T</c> [in] The array to be examined.
    ///  </param>
    ///  <param name="AComparer"><c>TComparison&lt;T&gt;</c> [in] Reference to a
    ///  function that compares two elements of type <c>T</c>. Used to determine
    ///  the ordering of the elements of <c>A</c>.</param>
    ///  <param name="AMinValue"><c>T</c> [out] Set to the value of the smallest
    ///  element of <c>A</c>.</param>
    ///  <param name="AMaxValue"><c>T</c> [out] Set to the value of the largest
    ///  element of <c>A</c>.</param>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class procedure MinMax<T>(const A: array of T;
      const AComparer: TComparison<T>; out AMinValue, AMaxValue: T);
      overload; static;

    ///  <summary>Finds the minimum and maximum values of a non empty array.
    ///  </summary>
    ///  <param name="A"><c>array of T</c> [in] The array to be examined.
    ///  </param>
    ///  <param name="AComparer"><c>IComparer&lt;T&gt;</c> [in] Reference to an
    ///  object that can be used to compare two elements of type <c>T</c>. Used
    ///  to determine the ordering of the elements of <c>A</c>.</param>
    ///  <param name="AMinValue"><c>T</c> [out] Set to the value of the smallest
    ///  element of <c>A</c>.</param>
    ///  <param name="AMaxValue"><c>T</c> [out] Set to the value of the largest
    ///  element of <c>A</c>.</param>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class procedure MinMax<T>(const A: array of T;
      AComparer: IComparer<T>; out AMinValue, AMaxValue: T);
      overload; static;

    ///  <summary>Finds the minimum and maximum values of a non empty array.
    ///  </summary>
    ///  <param name="A"><c>array of T</c> [in] The array to be examined.
    ///  </param>
    ///  <param name="AMinValue"><c>T</c> [out] Set to the value of the smallest
    ///  element of <c>A</c>.</param>
    ///  <param name="AMaxValue"><c>T</c> [out] Set to the value of the largest
    ///  element of <c>A</c>.</param>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    ///  <remarks>The default comparer for type <c>T</c> is used to determine
    ///  the ordering of the elements of <c>A</c>.</remarks>
    class procedure MinMax<T>(const A: array of T; out AMinValue, AMaxValue: T);
      overload; static;

    ///  <summary>Checks if all elements of a non-empty array comply with a
    ///  given constraint.</summary>
    ///  <param name="A"><c>A</c> [in] The array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraint&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element. Returns <c>True</c> if the element
    ///  meets the required criteria or <c>False</c> otherwise.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if all elements of <c>A</c> meet
    ///  the given constraint or <c>False</c> otherwise.</returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class function Every<T>(const A: array of T;
      const AConstraint: TConstraint<T>): Boolean;
      overload; static;

    ///  <summary>Checks if all elements of a non-empty array comply with a
    ///  given constraint.</summary>
    ///  <param name="A"><c>A</c> [in] The array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraintEx&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element, the index of the current element in
    ///  <c>A</c> and a reference to <c>A</c>. Returns <c>True</c> if the
    ///  element meets the required criteria or <c>False</c> otherwise.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if all elements of <c>A</c> meet
    ///  the given constraint or <c>False</c> otherwise.</returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class function Every<T>(const A: array of T;
      const AConstraint: TConstraintEx<T>): Boolean;
      overload; static;

    ///  <summary>Checks if one or more elements of a non-empty array comply
    ///  with a given constraint.</summary>
    ///  <param name="A"><c>A</c> [in] The array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraint&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element. Returns <c>True</c> if the element
    ///  meets the required criteria or <c>False</c> otherwise.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if some elements of <c>A</c> meet
    ///  the given constraint or <c>False</c> otherwise.</returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class function Some<T>(const A: array of T;
      const AConstraint: TConstraint<T>): Boolean;
      overload; static;

    ///  <summary>Checks if one or more elements of a non-empty array comply
    ///  with a given constraint.</summary>
    ///  <param name="A"><c>A</c> [in] The array to be checked.</param>
    ///  <param name="AConstraint"><c>TConstraintEx&lt;T&gt;</c> [in] Constraint
    ///  function called for each element of <c>A</c>. The function is passed
    ///  the value of the current element, the index of the current element in
    ///  <c>A</c> and a reference to <c>A</c>. Returns <c>True</c> if the
    ///  element meets the required criteria or <c>False</c> otherwise.</param>
    ///  <returns><c>Boolean</c>. <c>True</c> if some elements of <c>A</c> meet
    ///  the given constraint or <c>False</c> otherwise.</returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class function Some<T>(const A: array of T;
      const AConstraint: TConstraintEx<T>): Boolean;
      overload; static;

    ///  <summary>Enumerates all the elements of an array, passing each in turn
    ///  to a callback procedure.</summary>
    ///  <param name="A"><c>A</c> [in] The array to be enumerated.</param>
    ///  <param name="ACallback"><c>TCallback&lt;T&gt;</c> [in] Procedure to be
    ///  called for each element of <c>A</c>. The current element is passed as a
    ///  parameter.</param>
    class procedure ForEach<T>(const A: array of T;
      const ACallback: TCallback<T>);
      overload; static;

    ///  <summary>Enumerates all the elements of an array, passing each in turn
    ///  to a callback procedure.</summary>
    ///  <param name="A"><c>A</c> [in] The array to be enumerated.</param>
    ///  <param name="ACallback"><c>TCallbackEx&lt;T&gt;</c> [in] Procedure to
    ///  be called for each element of <c>A</c>. Passed the element, the index
    ///  of the element in <c>A</c> and a reference to <c>A</c> as parameters.
    ///  </param>
    class procedure ForEach<T>(const A: array of T;
      const ACallback: TCallbackEx<T>);
      overload; static;

    ///  <summary>Transforms the elements, of type <c>TIn</c>, of the given
    ///  array into elements of type <c>TOut</c> of the returned array.
    ///  </summary>
    ///  <param name="A"><c>array of TIn</c> [in] Array whose elements are to be
    ///  transformed.</param>
    ///  <param name="ATransformFunc"><c>TTransformer&lt;Tin,TOut&gt;</c> [in]
    ///  Reference to a function that transforms a value of type <c>TIn</c> to
    ///  another value of type <c>TOut</c>. This function is called once per
    ///  element of <c>A</c>. The current element is passed as a parameter. The
    ///  function result is stored in the output array.</param>
    ///  <returns><c>TArray&lt;TOut&gt;</c>. An array of transformed values.
    ///  </returns>
    ///  <remarks>The returned array is the same length as the input array and
    ///  each element of <c>A</c> corresponds to the element at the same index
    ///  in the returned array.</remarks>
    class function Transform<TIn,TOut>(const A: array of TIn;
      const ATransformFunc: TTransformer<TIn,TOut>): TArray<TOut>;
      overload; static;

    ///  <summary>Transforms the elements, of type <c>TIn</c>, of the given
    ///  array into elements of type <c>TOut</c> of the returned array.
    ///  </summary>
    ///  <param name="A"><c>array of TIn</c> [in] Array whose elements are to be
    ///  transformed.</param>
    ///  <param name="ATransformFunc"><c>TTransformerEx&lt;Tin,TOut&gt;</c> [in]
    ///  Reference to a function that transforms a value of type <c>TIn</c> to
    ///  another value of type <c>TOut</c>. Called for each element of <c>A</c>.
    ///  The function receives the current element, the index of the element in
    ///  <c>A</c> and a reference to <c>A</c>. The function result is stored in
    ///  the output array.</param>
    ///  <returns><c>TArray&lt;TOut&gt;</c>. An array of transformed values.
    ///  </returns>
    ///  <remarks>The returned array is the same length as the input array and
    ///  each element of <c>A</c> corresponds to the element at the same index
    ///  in the returned array.</remarks>
    class function Transform<TIn,TOut>(const A: array of TIn;
      const ATransformFunc: TTransformerEx<TIn,TOut>): TArray<TOut>;
      overload; static;

    ///  <summary>Reduces the elements of a non-empty array to a single value of
    ///  the same type.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be processed.</param>
    ///  <param name="AReducer"><c>TReducer&lt;T&gt;</c> [in] Callback function
    ///  executed for all but the first element of the array. Its return value
    ///  becomes the value of the accumulator parameter on the next invocation
    ///  of the callback. The first invocation receives the value of the first
    ///  element of the array as its accumulator parameter. The return value of
    ///  the last invocation becomes the return value of <c>Reduce</c>.</param>
    ///  <returns><c>T</c>. The value that results from running <c>AReducer</c>
    ///  over the elements of <c>A</c>.</returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class function Reduce<T>(const A: array of T;
      const AReducer: TReducer<T>): T;
      overload; static;

    ///  <summary>Reduces the elements of an array to a single value of the same
    ///  type.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be processed.</param>
    ///  <param name="AReducer"><c>TReducer&lt;T&gt;</c> [in] Callback function
    ///  executed for each element in the array. Its return value becomes the
    ///  value of the accumulator parameter on the next invocation of the
    ///  callback. The return value of the last invocation becomes the return
    ///  value of <c>Reduce</c>.</param>
    ///  <param name="AInitialValue"><c>T</c> [in] The initial value of the
    ///  accumulator parameter passed to the first invocation of
    ///  <c>AReducer</c>.</param>
    ///  <returns><c>T</c>. The value that results from running <c>AReducer</c>
    ///  over each element of <c>A</c>.</returns>
    class function Reduce<T>(const A: array of T; const AReducer: TReducer<T>;
      const AInitialValue: T): T;
      overload; static;

    ///  <summary>Reduces the elements of an array to a single value of the same
    ///  type.</summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be processed.</param>
    ///  <param name="AReducer"><c>TReducerEx&lt;T&gt;</c> [in] Callback
    ///  function executed for each element in the array. Its return value
    ///  becomes the value of the accumulator parameter on the next invocation
    ///  of the callback. The return value of the last invocation becomes the
    ///  return value of <c>Reduce</c>. The function also receives the index of
    ///  the current element in <c>A</c> and a reference to <c>A</c> as
    ///  parameters.</param>
    ///  <param name="AInitialValue"><c>T</c> [in] The initial value of the
    ///  accumulator parameter passed to the first invocation of
    ///  <c>AReducer</c>.</param>
    ///  <returns><c>T</c>. The value that results from running <c>AReducer</c>
    ///  over each element of <c>A</c>.</returns>
    class function Reduce<T>(const A: array of T; const AReducer: TReducerEx<T>;
      const AInitialValue: T): T;
      overload; static;

    ///  <summary>Reduces the elements of an array to a single value of an
    ///  optionally different type.</summary>
    ///  <param name="A"><c>array of TIn</c> [in] Array to be processed.</param>
    ///  <param name="AReducer"><c>TReducer&lt;TIn,TOut&gt;</c> [in] Callback
    ///  function executed for each element in the array. Its return value
    ///  becomes the value of the accumulator parameter on the next invocation
    ///  of the callback. The return value of the last invocation becomes the
    ///  return value of <c>Reduce</c>.</param>
    ///  <param name="AInitialValue"><c>TOut</c> [in] The initial value of the
    ///  accumulator parameter passed to the first invocation of
    ///  <c>AReducer</c>.</param>
    ///  <returns><c>TOut</c>. The value that results from running
    ///  <c>AReducer</c> over each element of <c>A</c>.</returns>
    class function Reduce<TIn,TOut>(const A: array of TIn;
      const AReducer: TReducer<TIn,TOut>; const AInitialValue: TOut): TOut;
      overload; static;

    ///  <summary>Reduces the elements of an array to a single value of an
    ///  optionally different type.</summary>
    ///  <param name="A"><c>array of TIn</c> [in] Array to be processed.</param>
    ///  <param name="AReducer"><c>TReducerEx&lt;TIn,TOut&gt;</c> [in] Callback
    ///  function executed for each element in the array. Its return value
    ///  becomes the value of the accumulator parameter on the next invocation
    ///  of the callback. The return value of the last invocation becomes the
    ///  return value of <c>Reduce</c>. The function also receives the index of
    ///  the current element in <c>A</c> and a reference to <c>A</c> as
    ///  parameters.</param>
    ///  <param name="AInitialValue"><c>TOut</c> [in] The initial value of the
    ///  accumulator parameter passed to the first invocation of
    ///  <c>AReducer</c>.</param>
    ///  <returns><c>TOut</c>. The value that results from running
    ///  <c>AReducer</c> over each element of <c>A</c>.</returns>
    class function Reduce<TIn,TOut>(const A: array of TIn;
      const AReducer: TReducerEx<TIn,TOut>; const AInitialValue: TOut): TOut;
      overload; static;

    ///  <summary>Returns a sorted copy of an array.</summary>
    ///  <param name="A"><c>array of T</c>. [in] Array to be sorted.</param>
    ///  <param name="AComparer"><c>TComparison&lt;T&gt;</c> [in] Reference to a
    ///  function that compares two elements of type <c>T</c>. Used to determine
    ///  the sort order.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. The sorted array.</returns>
    class function CopySorted<T>(const A: array of T;
      const AComparer: TComparison<T>): TArray<T>;
      overload; static;

    ///  <summary>Returns a sorted copy of an array.</summary>
    ///  <param name="A"><c>array of T</c>. [in] Array to be sorted.</param>
    ///  <param name="AComparer"><c>IComparer&lt;T&gt;</c> [in] Reference to an
    ///  object that can be used to compare two elements of type <c>T</c>. Used
    ///  to determine the sort order.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. The sorted array.</returns>
    class function CopySorted<T>(const A: array of T;
      const AComparer: IComparer<T>): TArray<T>;
      overload; static;

    ///  <summary>Returns a sorted copy of an array.</summary>
    ///  <param name="A"><c>array of T</c>. [in] Array to be sorted.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. The sorted array.</returns>
    ///  <remarks>The default comparer for type <c>T</c> is used to determine
    ///  the sort order.</remarks>
    class function CopySorted<T>(const A: array of T): TArray<T>;
      overload; static;

    ///  <summary>Sorts an array in place.</summary>
    ///  <param name="A"><c>array of T</c>. [in/out] The array to be sorted is
    ///  passed in and the sorted array is passed out.</param>
    ///  <param name="AComparer"><c>TComparison&lt;T&gt;</c> [in] Reference to a
    ///  function that compares two elements of type <c>T</c>. Used to determine
    ///  the sort order.</param>
    class procedure Sort<T>(var A: array of T; const AComparer: TComparison<T>);
      overload; static;

    ///  <summary>Sorts an array in place.</summary>
    ///  <param name="A"><c>array of T</c>. [in/out] The array to be sorted is
    ///  passed in and the sorted array is passed out.</param>
    ///  <param name="AComparer"><c>IComparer&lt;T&gt;</c> [in] Reference to an
    ///  object that can be used to compare two elements of type <c>T</c>. Used
    ///  to determine the sort order.</param>
    class procedure Sort<T>(var A: array of T; const AComparer: IComparer<T>);
      overload; static;

    ///  <summary>Sorts an array in place.</summary>
    ///  <param name="A"><c>array of T</c>. [in/out] The array to be sorted is
    ///  passed in and the sorted array is passed out.</param>
    ///  <remarks>The default comparer for type <c>T</c> is used to determine
    ///  the sort order.</remarks>
    class procedure Sort<T>(var A: array of T);
      overload; static;

    ///  <summary>Returns a copy of an array with no duplicated elements.
    ///  </summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be de-duplicated.
    ///  </param>
    ///  <param name="AEqualityComparer"><c>TEqualityComparison&lt;T&gt;</c>
    ///  [in] Reference to a function used to determine if two values of type
    ///  <c>T</c> are equal. Used to test elements of <c>A</c> for equality.
    ///  </param>
    ///  <returns><c>TArray&lt;T&gt;</c>. The de-duplicated array.</returns>
    class function DeDup<T>(const A: array of T;
      const AEqualityComparer: TEqualityComparison<T>): TArray<T>;
      overload; static;

    ///  <summary>Returns a copy of an array with no duplicated elements.
    ///  </summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be de-duplicated.
    ///  </param>
    ///  <param name="AEqualityComparer"><c>IEqualityComparer&lt;T&gt;</c> [in]
    ///  Reference to an object that can be used to determine if two values of
    ///  type <c>T</c> are equal. Used to test elements of <c>A</c> for
    ///  equality.</param>
    ///  <returns><c>TArray&lt;T&gt;</c>. The de-duplicated array.</returns>
    class function DeDup<T>(const A: array of T;
      const AEqualityComparer: IEqualityComparer<T>): TArray<T>;
      overload; static;

    ///  <summary>Returns a copy of an array with no duplicated elements.
    ///  </summary>
    ///  <param name="A"><c>array of T</c> [in] Array to be de-duplicated.
    ///  </param>
    ///  <remarks>The default equality comparer for type <c>T</c> is used to
    ///  test elements of <c>A</c> for equality.</remarks>
    ///  <returns><c>TArray&lt;T&gt;</c>. The de-duplicated array.</returns>
    class function DeDup<T>(const A: array of T): TArray<T>;
      overload; static;

    ///  <summary>Deletes the element at a given index from an array.</summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array from which the element
    ///  is to be removed. The modified array is passed out.</param>
    ///  <param name="AIndex"><c>Integer</c> [in] Index of the element to be
    ///  deleted.</param>
    ///  <remarks>If <c>AIndex</c> is out of range then no action is taken and
    ///  <c>A</c> is not modified.</remarks>
    class procedure Delete<T>(var A: TArray<T>; const AIndex: Integer);
      overload; static;

    ///  <summary>Deletes elements at given indices from an array.</summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array from which the
    ///  elements are to be removed. The modified array is passed out.</param>
    ///  <param name="AIndices"><c>array of Integer</c> [in] Array containing
    ///  the indices of the elements to be deleted.</param>
    ///  <remarks>If any index in <c>AIndices</c> is out of range then that
    ///  index is ignored. Duplicate indices are also ignored. If no index is in
    ///  range then <c>A</c> is not modified.</remarks>
    class procedure Delete<T>(var A: TArray<T>;
      const AIndices: array of Integer);
      overload; static;

    ///  <summary>Deletes a contiguous range of elements from an array.
    ///  </summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array from which the range
    ///  of elements is to be deleted. The modified array is passed out.</param>
    ///  <param name="AStartIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the start of the deleted range of elements.</param>
    ///  <param name="AEndIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the end of the deleted range of elements.</param>
    ///  <remarks>
    ///  <para>If <c>AStartIndex</c> &lt;= <c>0</c> then the range to be deleted
    ///  begins at the first element of <c>A</c>.</para>
    ///  <para>If <c>AEndIndex</c> &gt;= <c>Length(A)</c> then the range to be
    ///  deleted continues to the end of <c>A</c>.</para>
    ///  <para>If <c>AEndIndex</c> is &lt; <c>AStartIndex</c> then nothing is
    ///  deleted and no change is made to <c>A</c>.</para>
    ///  </remarks>
    class procedure DeleteRange<T>(var A: TArray<T>;
      AStartIndex, AEndIndex: Integer);
      overload; static;

    ///  <summary>Deletes a contiguous range of elements from the end of an
    ///  array.</summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array from which the range
    ///  of elements is to be deleted. The modified array is passed out.</param>
    ///  <param name="AStartIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the start of the deleted range of elements.</param>
    ///  <remarks>If <c>AStartIndex</c> &lt;= <c>0</c> then all elements of
    ///  <c>A</c> are deleted.</remarks>
    class procedure DeleteRange<T>(var A: TArray<T>; AStartIndex: Integer);
      overload; static;

    ///  <summary>Deletes the element at a given index in an array and releases
    ///  any resource associated with the deleted element.</summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array from which the element
    ///  is to be deleted. The modified array is passed out.</param>
    ///  <param name="AIndex"><c>Integer</c> [in] Index of the element to be
    ///  deleted.</param>
    ///  <param name="AReleaser"><c>TCallback&lt;T&gt;</c> [in] Callback that
    ///  must release any resource associated with the deleted element.</param>
    ///  <remarks>If <c>AIndex</c> is out of range then no action is taken and
    ///  <c>A</c> is not modified and no resource is released.</remarks>
    class procedure DeleteAndRelease<T>(var A: TArray<T>; const AIndex: Integer;
      const AReleaser: TCallback<T>);
      overload; static;

    ///  <summary>Deletes elements at given indices from an array and releases
    ///  any resources associated with the deleted elements.</summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array from which the
    ///  elements are to be deleted. The modified array is passed out.</param>
    ///  <param name="AIndices"><c>array of Integer</c> [in] Array containing
    ///  the indices of the elements to be deleted.</param>
    ///  <param name="AReleaser"><c>TCallback&lt;T&gt;</c> [in] Procedure called
    ///  for each deleted element of the array that must release the resource
    ///  associated with the element.</param>
    ///  <remarks>If any index in <c>AIndices</c> is out of range then that
    ///  index is ignored. Duplicate indices are also ignored. If no index is in
    ///  range then <c>A</c> is not modified and no resource is released.
    ///  </remarks>
    class procedure DeleteAndRelease<T>(var A: TArray<T>;
      const AIndices: array of Integer; const AReleaser: TCallback<T>);
      overload; static;

    ///  <summary>Deletes a contiguous range of elements from an array and
    ///  releases any resources associated with the deleted elements.</summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array from which the range
    ///  of elements is to be deleted. The modified array is passed out.</param>
    ///  <param name="AStartIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the start of the deleted range of elements.</param>
    ///  <param name="AEndIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the end of the deleted range of elements.</param>
    ///  <param name="AReleaser"><c>TCallback&lt;T&gt;</c> [in] Procedure called
    ///  for each deleted element of the array that must release the resource
    ///  associated with the element.</param>
    ///  <remarks>
    ///  <para>If <c>AStartIndex</c> &lt;= <c>0</c> then the range to be deleted
    ///  begins at the first element of <c>A</c>.</para>
    ///  <para>If <c>AEndIndex</c> &gt;= <c>Length(A)</c> then the range to be
    ///  deleted continues to the end of <c>A</c>.</para>
    ///  <para>If <c>AEndIndex</c> is &lt; <c>AStartIndex</c> then nothing is
    ///  deleted and no change is made to <c>A</c>.</para>
    ///  </remarks>
    class procedure DeleteAndReleaseRange<T>(var A: TArray<T>;
      AStartIndex, AEndIndex: Integer; const AReleaser: TCallback<T>);
      overload; static;

    ///  <summary>Deletes a contiguous range of elements from the end of an
    ///  array and releases any resources associated with the deleted elements.
    ///  </summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array from which the range
    ///  of elements is to be deleted. The modified array is passed out.</param>
    ///  <param name="AStartIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the start of the deleted range of elements.</param>
    ///  <param name="AReleaser"><c>TCallback&lt;T&gt;</c> [in] Procedure called
    ///  for each deleted element of the array that must release the resource
    ///  associated with the element.</param>
    ///  <remarks>If <c>AStartIndex</c> &lt;= <c>0</c> then all elements of
    ///  <c>A</c> are deleted.</remarks>
    class procedure DeleteAndReleaseRange<T>(var A: TArray<T>;
      AStartIndex: Integer; const AReleaser: TCallback<T>);
      overload; static;

    ///  <summary>Deletes the element at a given index in an array of
    ///  <c>TObject</c> descendants and frees the deleted object.</summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array of <c>TObject</c>
    ///  descendants from which the element is to be deleted and freed. The
    ///  modified array is passed out.</param>
    ///  <param name="AIndex"><c>Integer</c> [in] Index of the element to be
    ///  deleted and freed.</param>
    ///  <remarks>If <c>AIndex</c> is out of range then no action is taken,
    ///  <c>A</c> is not modified and no object is freed.</remarks>
    class procedure DeleteAndFree<T: class>(var A: TArray<T>;
      const AIndex: Integer);
      overload; static;

    ///  <summary>Deletes elements at given indices from an array of
    ///  <c>TObject</c> descendants and frees the deleted objects.</summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array of <c>TObject</c>
    ///  descendants from which the elements are to be deleted and freed. The
    ///  modified array is passed out.</param>
    ///  <param name="AIndices"><c>array of Integer</c> [in] Array containing
    ///  the indices of the elements to be deleted.</param>
    ///  <remarks>If any index in <c>AIndices</c> is out of range then that
    ///  index is ignored. Duplicate indices are also ignored. If no index is in
    ///  range then <c>A</c> is not modified and no objects are freed.</remarks>
    class procedure DeleteAndFree<T: class>(var A: TArray<T>;
      const AIndices: array of Integer);
      overload; static;

    ///  <summary>Deletes a contiguous range of elements, which must be
    ///  <c>TObject</c> descendants, from an array and frees the deleted
    ///  objects.</summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array of <c>TObject</c>
    ///  descendants from which the range of elements are to be deleted and
    ///  freed. The modified array is passed out.</param>
    ///  <param name="AStartIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the start of the deleted range of elements.</param>
    ///  <param name="AEndIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the end of the deleted range of elements.</param>
    ///  <remarks>
    ///  <para>If <c>AStartIndex</c> &lt;= <c>0</c> then the range to be deleted
    ///  begins at the first element of <c>A</c>.</para>
    ///  <para>If <c>AEndIndex</c> &gt;= <c>Length(A)</c> then the range to be
    ///  deleted continues to the end of <c>A</c>.</para>
    ///  <para>If <c>AEndIndex</c> is &lt; <c>AStartIndex</c> then nothing is
    ///  deleted and no change is made to <c>A</c>.</para>
    ///  </remarks>
    class procedure DeleteAndFreeRange<T: class>(var A: TArray<T>;
      AStartIndex, AEndIndex: Integer);
      overload; static;

    ///  <summary>Deletes a contiguous range of elements, which must be
    ///  <c>TObject</c> descendants, from the end of an array and frees the
    ///  deleted objects.</summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array of <c>TObject</c>
    ///  descendants from which the range of elements is to be deleted and
    ///  freed. The modified array is passed out.</param>
    ///  <param name="AStartIndex"><c>Integer</c> [in] The index in <c>A</c> of
    ///  the start of the deleted range of elements.</param>
    ///  <remarks>If <c>AStartIndex</c> &lt;= <c>0</c> then all elements of
    ///  <c>A</c> are deleted.</remarks>
    class procedure DeleteAndFreeRange<T: class>(var A: TArray<T>;
      AStartIndex: Integer);
      overload; static;

    ///  <summary>Inserts an element into an array at a given position.
    ///  </summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array into which the element
    ///  is to be inserted. The modified array is passed out.</param>
    ///  <param name="AValue"><c>T</c> [in] The value of the element to be
    ///  inserted.</param>
    ///  <param name="AIndex"><c>Integer</c> [in] The index before which the
    ///  element is to be inserted.</param>
    ///  <remarks>
    ///  <para>If <c>AIndex</c> &lt;= <c>0</c> then <c>AValue</c> is inserted at
    ///  the start of <c>A</c>.</para>
    ///  <para>If <c>0</c> &lt; <c>AIndex</c> &lt; <c>Length(A)</c> then
    ///  <c>AValue</c> is inserted immediatley before the element at
    ///  <c>AIndex</c>.</para>
    ///  <para>If <c>AIndex</c> &gt;= <c>Length(A)</c> then <c>AValue</c> is
    ///  inserted at the end of the array.</para>
    ///  </remarks>
    class procedure Insert<T>(var A: TArray<T>; AValue: T; AIndex: Integer);
      overload; static;

    ///  <summary>Inserts a contiguous sequence of elements into an array at a
    ///  given position.</summary>
    ///  <param name="A"><c>array of T</c> [in/out] Array into which the
    ///  elements are to be inserted. The modified array is passed out.</param>
    ///  <param name="AValues"><c>array of T</c> [in] The values of the elements
    ///   to be inserted.</param>
    ///  <param name="AIndex"><c>Integer</c> [in] The index before which the
    ///  elements are to be inserted.</param>
    ///  <remarks>
    ///  <para>If <c>AIndex</c> &lt;= <c>0</c> then the new elements are
    ///  inserted at the start of <c>A</c>.</para>
    ///  <para>If <c>0</c> &lt; <c>AIndex</c> &lt; <c>Length(A)</c> then the
    ///  new elements are inserted immediatley before the element at
    ///  <c>AIndex</c>.</para>
    ///  <para>If <c>AIndex</c> &gt;= <c>Length(A)</c> then the new elements are
    ///  inserted at the end of the array.</para>
    ///  </remarks>
    class procedure Insert<T>(var A: TArray<T>; const AValues: array of T;
      AIndex: Integer);
      overload; static;

    ///  <summary>Removes and returns the last element of a non-empty array.
    ///  </summary>
    ///  <param name="A"><c>TArray&lt;T&gt;</c> [in/out] Array to be updated.
    ///  The modified array is passed out.</param>
    ///  <returns><c>T</c>. The element that was removed from <c>A</c>.
    ///  </returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class function Pop<T>(var A: TArray<T>): T;
      static;

    ///  <summary>Deletes the last element of a non-empty array and releases any
    ///  resources associated with the deleted element.</summary>
    ///  <param name="A"><c>TArray&lt;T&gt;</c> [in/out] Array to be updated.
    ///  The modified array is passed out.</param>
    ///  <param name="AReleaser"><c>TCallback&lt;T&gt;</c> [in] Procedure that
    ///  must release any resource associated with the removed element, which is
    ///  passed as a parameter.</param>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class procedure PopAndRelease<T>(var A: TArray<T>;
      const AReleaser: TCallback<T>);
      static;

    ///  <summary>Removes and frees the last element of a non-empty array of
    ///  <c>TObject</c> decendants.
    ///  </summary>
    ///  <param name="A"><c>TArray&lt;T&gt;</c> [in/out] Array of <c>TObject</c>
    ///  descendants to be updated. The modified array is passed out.</param>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class procedure PopAndFree<T: class>(var A: TArray<T>);
      static;

    ///  <summary>Adds an element to the end of an array.</summary>
    ///  <param name="A"><c>TArray&lt;T&gt;</c> [in/out] Array to be updated.
    ///  The modified array is passed out.</param>
    ///  <param name="AValue"><c>T</c> The value to be appended to <c>A</c>.
    ///  </param>
    class procedure Push<T>(var A: TArray<T>; const AValue: T);
      static;

    ///  <summary>Removes and returns the first element of a non-empty array.
    ///  </summary>
    ///  <param name="A"><c>TArray&lt;T&gt;</c> [in/out] Array to be updated.
    ///  The modified array is passed out.</param>
    ///  <returns><c>T</c>. The element that was removed from <c>A</c>.
    ///  </returns>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class function Shift<T>(var A: TArray<T>): T;
      static;

    ///  <summary>Deletes the first element of a non-empty array and releases
    ///  any resources associated with the deleted element.</summary>
    ///  <param name="A"><c>TArray&lt;T&gt;</c> [in/out] Array to be updated.
    ///  The modified array is passed out.</param>
    ///  <param name="AReleaser"><c>TCallback&lt;T&gt;</c> [in] Procedure that
    ///  must release any resource associated with the removed element, which is
    ///  passed as a parameter.</param>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class procedure ShiftAndRelease<T>(var A: TArray<T>;
      const AReleaser: TCallback<T>);
      static;

    ///  <summary>Removes and frees the first element of a non-empty array of
    ///  <c>TObject</c> decendants.
    ///  </summary>
    ///  <param name="A"><c>TArray&lt;T&gt;</c> [in/out] Array of <c>TObject</c>
    ///  descendants to be updated. The modified array is passed out.</param>
    ///  <exception><c>EAssertionFailed</c> raised if <c>A</c> is empty.
    ///  </exception>
    class procedure ShiftAndFree<T: class>(var A: TArray<T>);
      static;

    ///  <summary>Adds an element to the start of an array.</summary>
    ///  <param name="A"><c>TArray&lt;T&gt;</c> [in/out] Array to be updated.
    ///  The modified array is passed out.</param>
    ///  <param name="AValue"><c>T</c> The value to be prepended to <c>A</c>.
    ///  </param>
    class procedure UnShift<T>(var A: TArray<T>; const AValue: T);
      static;

  end;

implementation

uses
  {$IFDEF SupportsUnitScopeNames}
  System.Types
  , System.Math
  , System.Generics.Collections
  {$ELSE}
  Types
  , Math
  , Generics.Collections
  {$ENDIF}
  ;

{ TArrayUtils }

class function TArrayUtils.Chop<T>(var A: TArray<T>; AStartIndex,
  AEndIndex: Integer): TArray<T>;
begin
  Result := Slice<T>(A, AStartIndex, AEndIndex);
  if Length(Result) = 0 then
    Exit;
  DeleteRange<T>(A, AStartIndex, AEndIndex);
end;

class function TArrayUtils.Chop<T>(var A: TArray<T>;
  AStartIndex: Integer): TArray<T>;
begin
  Result := Chop<T>(A, AStartIndex, Pred(Length(A)));
end;

class procedure TArrayUtils.ClampInRange(var AValue: Integer; const ARangeLo,
  ARangeHi: Integer);
begin
  AValue := IntMin(IntMax(ARangeLo, AValue), ARangeHi);
end;

class function TArrayUtils.CleanIndices(const AIndices: array of Integer;
  const AArrayLength: Integer; const ADeDup: Boolean): TArray<Integer>;
var
  IdxList: TList<Integer>;
  Idx: Integer;
begin
  IdxList := TList<Integer>.Create;
  try
    for Idx in AIndices do
    begin
      if (Idx >= 0) and (Idx < AArrayLength)
        and not (ADeDup and IdxList.Contains(Idx)) then
        IdxList.Add(Idx);
    end;
    Result := IdxList.ToArray;
  finally
    IdxList.Free;
  end;
end;

class function TArrayUtils.Compare<T>(const ALeft, ARight: array of T;
  const AComparer: TComparison<T>): Integer;
var
  Idx: Integer;
  ShortestLength: Integer;
begin
  ShortestLength := IntMin(Length(ALeft), Length(ARight));
  Idx := 0;
  while (Idx < ShortestLength) do
  begin
    Result := AComparer(ALeft[Idx], ARight[Idx]);
    if Result <> EqualsValue then
      Exit;
    Inc(Idx);
  end;
  // If we get here all elements in shortest array are equal to elements at same
  // index in longest array.
  if Length(ALeft) > Length(ARight) then
    Result := 1
  else if Length(ALeft) < Length(ARight) then
    Result := LessThanValue
  else // lengths equal
    Result := EqualsValue;
end;

class function TArrayUtils.Compare<T>(const ALeft, ARight: array of T;
  const AComparer: IComparer<T>): Integer;
begin
  Result := Compare<T>(
    ALeft,
    ARight,
    function (const L, R: T): Integer
    begin
      Result := AComparer.Compare(L, R);
    end
  );
end;

class function TArrayUtils.Compare<T>(const ALeft, ARight: array of T): Integer;
begin
  Result := Compare<T>(
    ALeft,
    ARight,
    function (const L, R: T): Integer
    begin
      Result := TComparer<T>.Default.Compare(L, R);
    end
  );
end;

class function TArrayUtils.Concat<T>(const A, B: array of T): TArray<T>;
var
  ResLength: Integer;
  ResIdx: Integer;
begin
  ResLength := Length(A) + Length(B);
  SetLength(Result, ResLength);
  ResIdx := 0;
  CopyIntoArray<T>(Result, ResIdx, A);
  CopyIntoArray<T>(Result, ResIdx, B);
end;

class function TArrayUtils.Contains<T>(const AItem: T; const A: array of T;
  const AEqualityComparer: TEqualityComparison<T>): Boolean;
var
  Elem: T;
begin
  Result := False;
  for Elem in A do
    if AEqualityComparer(Elem, AItem) then
      Exit(True);
end;

class function TArrayUtils.Contains<T>(const AItem: T; const A: array of T;
  const AEqualityComparer: IEqualityComparer<T>): Boolean;
begin
  Result := Contains<T>(
    AItem,
    A,
    function (const L, R: T): Boolean
    begin
      Result := AEqualityComparer.Equals(L, R);
    end
  );
end;

class function TArrayUtils.Contains<T>(const AItem: T;
  const A: array of T): Boolean;
begin
  Result := Contains<T>(
    AItem,
    A,
    function (const L, R: T): Boolean
    begin
      Result := TEqualityComparer<T>.Default.Equals(L, R);
    end
  );
end;

class function TArrayUtils.Copy<T>(const A: array of T): TArray<T>;
var
  Idx: Integer;
begin
  SetLength(Result, Length(A));
  Idx := 0;
  CopyIntoArray<T>(Result, Idx, A);
end;

class function TArrayUtils.Copy<T>(const A: array of T;
  const ACloner: TCloner<T>): TArray<T>;
var
  Idx: Integer;
begin
  SetLength(Result, Length(A));
  for Idx := 0 to Pred(Length(A)) do
    Result[Idx] := ACloner(A[Idx]);
end;

class procedure TArrayUtils.CopyIntoArray<T>(var ADestArray: TArray<T>;
  var ADestArrayIdx: Integer; const ASourceArray: array of T);
var
  SrcArrayIdx: Integer;
begin
  for SrcArrayIdx := 0 to Pred(Length(ASourceArray)) do
  begin
    ADestArray[ADestArrayIdx] := ASourceArray[SrcArrayIdx];
    Inc(ADestArrayIdx);
  end;
end;

class function TArrayUtils.CopyReversed<T>(const A: array of T): TArray<T>;
var
  I: Integer;
begin
  SetLength(Result, Length(A));
  for I := 0 to Pred(Length(A)) do
    Result[High(A)-I] := A[I];
end;

class function TArrayUtils.CopySorted<T>(const A: array of T;
  const AComparer: TComparison<T>): TArray<T>;
begin
  Result := Copy<T>(A);
  Sort<T>(Result, AComparer);
end;

class function TArrayUtils.CopySorted<T>(const A: array of T;
  const AComparer: IComparer<T>): TArray<T>;
begin
  Result := Copy<T>(A);
  Sort<T>(Result, AComparer);
end;

class function TArrayUtils.CopySorted<T>(const A: array of T): TArray<T>;
begin
  Result := Copy<T>(A);
  Sort<T>(Result);
end;

class function TArrayUtils.DeDup<T>(const A: array of T;
  const AEqualityComparer: TEqualityComparison<T>): TArray<T>;
var
  Elem: T;
begin
  SetLength(Result, 0);
  for Elem in A do
    if not Contains<T>(Elem, Result, AEqualityComparer) then
      Push<T>(Result, Elem);
end;

class function TArrayUtils.DeDup<T>(const A: array of T;
  const AEqualityComparer: IEqualityComparer<T>): TArray<T>;
begin
  Result := DeDup<T>(
    A,
    function(const L, R: T): Boolean
    begin
      Result := AEqualityComparer.Equals(L, R);
    end
  );
end;

class function TArrayUtils.DeDup<T>(const A: array of T): TArray<T>;
begin
  Result := DeDup<T>(
    A,
    function(const L, R: T): Boolean
    begin
      Result := TEqualityComparer<T>.Default.Equals(L, R);
    end
  );
end;

class procedure TArrayUtils.Delete<T>(var A: TArray<T>; const AIndex: Integer);
begin
  if (AIndex < 0) or (AIndex >= Length(A)) then
    Exit;
  ShuffleDown<T>(A, AIndex, Pred(High(A)), 1);
  SetLength(A, Pred(Length(A)));
end;

class procedure TArrayUtils.Delete<T>(var A: TArray<T>;
  const AIndices: array of Integer);
var
  CleanedIndices: TArray<Integer>;
  DelIdx: Integer;
begin
  CleanedIndices := CopySorted<Integer>(
    CleanIndices(AIndices, Length(A), True),
    // reverse sort indices
    function (const L, R: Integer): Integer begin Result := R - L; end
  );
  for DelIdx := 0 to Pred(Length(CleanedIndices)) do
    ShuffleDown<T>(A, CleanedIndices[DelIdx], High(A) - Succ(DelIdx), 1);
  SetLength(A, Length(A) - Length(CleanedIndices));
end;

class procedure TArrayUtils.DeleteAndFree<T>(var A: TArray<T>;
  const AIndex: Integer);
begin
  DeleteAndRelease<T>(
    A, AIndex, procedure (const AElem: T) begin AElem.Free; end
  );
end;

class procedure TArrayUtils.DeleteAndFree<T>(var A: TArray<T>;
  const AIndices: array of Integer);
begin
  DeleteAndRelease<T>(
    A, AIndices, procedure (const AElem: T) begin AElem.Free; end
  );
end;

class procedure TArrayUtils.DeleteAndFreeRange<T>(var A: TArray<T>; AStartIndex,
  AEndIndex: Integer);
begin
  DeleteAndReleaseRange<T>(
    A, AStartIndex, AEndIndex, procedure (const AElem: T) begin AElem.Free; end
  );
end;

class procedure TArrayUtils.DeleteAndFreeRange<T>(var A: TArray<T>;
  AStartIndex: Integer);
begin
  DeleteAndFreeRange<T>(A, AStartIndex, Pred(Length(A)));
end;

class procedure TArrayUtils.DeleteAndRelease<T>(var A: TArray<T>;
  const AIndices: array of Integer; const AReleaser: TCallback<T>);
var
  Resource: T;
  DeletedResources: TArray<T>;
  CleanedIndices: TArray<Integer>;
  Idx: Integer;
begin
  CleanedIndices := CleanIndices(AIndices, Length(A), True);
  SetLength(DeletedResources, Length(CleanedIndices));
  for Idx := 0 to Pred(Length(CleanedIndices)) do
    DeletedResources[Idx] := A[CleanedIndices[Idx]];
  Delete<T>(A, CleanedIndices);
  for Resource in DeletedResources do
    AReleaser(Resource);
end;

class procedure TArrayUtils.DeleteAndReleaseRange<T>(var A: TArray<T>;
  AStartIndex: Integer; const AReleaser: TCallback<T>);
begin
  DeleteAndReleaseRange<T>(A, AStartIndex, Pred(Length(A)), AReleaser);
end;

class procedure TArrayUtils.DeleteAndReleaseRange<T>(var A: TArray<T>;
  AStartIndex, AEndIndex: Integer; const AReleaser: TCallback<T>);
var
  DeletedElem: T;
begin
  for DeletedElem in Chop<T>(A, AStartIndex, AEndIndex) do
    AReleaser(DeletedElem);
end;

class procedure TArrayUtils.DeleteAndRelease<T>(var A: TArray<T>;
  const AIndex: Integer; const AReleaser: TCallback<T>);
var
  Resource: T;
begin
  if (AIndex < 0) or (AIndex >= Length(A)) then
    Exit;
  Resource := A[AIndex];
  Delete<T>(A, AIndex);
  AReleaser(Resource);
end;

class procedure TArrayUtils.DeleteRange<T>(var A: TArray<T>; AStartIndex,
  AEndIndex: Integer);
var
  DelCount: Integer;
begin
  NormaliseArrayRange(Length(A), AStartIndex, AEndIndex, DelCount);
  if DelCount = 0 then
    Exit;
  ShuffleDown<T>(A, AStartIndex, Pred(Length(A)) - DelCount, DelCount);
  SetLength(A, Length(A) - DelCount);
end;

class procedure TArrayUtils.DeleteRange<T>(var A: TArray<T>;
  AStartIndex: Integer);
begin
  DeleteRange<T>(A, AStartIndex, Pred(Length(A)));
end;

class function TArrayUtils.Equal<T>(const ALeft, ARight: array of T;
  const AEqualityComparer: TEqualityComparison<T>): Boolean;
var
  I: Integer;
begin
  Result := Length(ALeft) = Length(ARight);
  if Result then
  begin
    for I := 0 to Pred(Length(ALeft)) do
      if not AEqualityComparer(ALeft[I], ARight[I]) then
        Exit(False);
  end
end;

class function TArrayUtils.Equal<T>(const ALeft, ARight: array of T;
  const AEqualityComparer: IEqualityComparer<T>): Boolean;
begin
  Result := Equal<T>(
    ALeft,
    ARight,
    function (const L, R: T): Boolean
    begin
      Result := AEqualityComparer.Equals(L, R);
    end
  );
end;

class function TArrayUtils.Equal<T>(const ALeft, ARight: array of T): Boolean;
begin
  Result := Equal<T>(
    ALeft,
    ARight,
    function (const L, R: T): Boolean
    begin
      Result := TEqualityComparer<T>.Default.Equals(L, R);
    end
  );
end;

class function TArrayUtils.EqualStart<T>(const ALeft, ARight: array of T;
  const ACount: Integer; const AEqualityComparer: TEqualityComparison<T>):
  Boolean;
var
  I: Integer;
begin
  Assert(ACount > 0);
  if (Length(ALeft) < ACount) or (Length(ARight) < ACount) then
    Exit(False);
  for I := 0 to Pred(ACount) do
    if not AEqualityComparer(ALeft[I], ARight[I]) then
      Exit(False);
  Result := True;
end;

class function TArrayUtils.EqualStart<T>(const ALeft, ARight: array of T;
  const ACount: Integer; const AEqualityComparer: IEqualityComparer<T>):
  Boolean;
begin
  Result := EqualStart<T>(
    ALeft,
    ARight,
    ACount,
    function (const L, R: T): Boolean
    begin
      Result := AEqualityComparer.Equals(L, R);
    end
  );
end;

class function TArrayUtils.EqualStart<T>(const ALeft, ARight: array of T;
  const ACount: Integer): Boolean;
begin
  Result := EqualStart<T>(
    ALeft,
    ARight,
    ACount,
    function (const L, R: T): Boolean
    begin
      Result := TEqualityComparer<T>.Default.Equals(L, R);
    end
  );
end;

class function TArrayUtils.Every<T>(const A: array of T;
  const AConstraint: TConstraint<T>): Boolean;
var
  Elem: T;
begin
  Assert(Length(A) > 0); // meaningless for empty array
  Result := True;
  for Elem in A do
    if not AConstraint(Elem) then
      Exit(False);
end;

class function TArrayUtils.Every<T>(const A: array of T;
  const AConstraint: TConstraintEx<T>): Boolean;
var
  Idx: Integer;
begin
  Assert(Length(A) > 0); // meaningless for empty array
  Result := True;
  for Idx := 0 to Pred(Length(A)) do
    if not AConstraint(A[Idx], Idx, A) then
      Exit(False);
end;

class function TArrayUtils.FindAll<T>(const A: array of T;
  const AConstraint: TConstraint<T>): TArray<T>;
var
  Results: TList<T>;
  Elem: T;
begin
  // tried writing this to call the TConstrainEx overload but this caused an
  // internal error in Delphi XE
  Results := TList<T>.Create;
  try
    for Elem in A do
      if AConstraint(Elem) then
        Results.Add(Elem);
    Result := Results.ToArray;
  finally
    Results.Free;
  end;
end;

class function TArrayUtils.FindAll<T>(const A: array of T;
  const AConstraint: TConstraintEx<T>): TArray<T>;
var
  Idx: Integer;
  Results: TList<T>;
begin
  Results := TList<T>.Create;
  try
    for Idx := 0 to Pred(Length(A)) do
      if AConstraint(A[Idx], Idx, A) then
        Results.Add(A[Idx]);
    Result := Results.ToArray;
  finally
    Results.Free;
  end;
end;

class function TArrayUtils.FindAllIndices<T>(const A: array of T;
  const AConstraint: TConstraint<T>): TArray<Integer>;
var
  Results: TList<Integer>;
  Idx: Integer;
begin
  // tried writing this to call the TConstrainEx overload but this caused an
  // internal error in Delphi XE
  Results := TList<Integer>.Create;
  try
    for Idx := 0 to Pred(Length(A)) do
      if AConstraint(A[Idx]) then
        Results.Add(Idx);
    Result := Results.ToArray;
  finally
    Results.Free;
  end;
end;

class function TArrayUtils.FindAllIndices<T>(const A: array of T;
  const AConstraint: TConstraintEx<T>): TArray<Integer>;
var
  Idx: Integer;
  Results: TList<Integer>;
begin
  Results := TList<Integer>.Create;
  try
    for Idx := 0 to Pred(Length(A)) do
      if AConstraint(A[Idx], Idx, A) then
        Results.Add(Idx);
    Result := Results.ToArray;
  finally
    Results.Free;
  end;
end;

class function TArrayUtils.FindDef<T>(const A: array of T;
  const AConstraint: TConstraint<T>; const ADefault: T): T;
begin
  if not TryFind<T>(A, AConstraint, Result) then
    Result := ADefault;
end;

class function TArrayUtils.FindDef<T>(const A: array of T;
  const AConstraint: TConstraintEx<T>; const ADefault: T): T;
begin
  if not TryFind<T>(A, AConstraint, Result) then
    Result := ADefault;
end;

class function TArrayUtils.FindIndex<T>(const A: array of T;
  const AConstraint: TConstraint<T>): Integer;
var
  Idx: Integer;
begin
  Result := -1;
  for Idx := 0 to Pred(Length(A)) do
    if AConstraint(A[Idx]) then
      Exit(Idx);
end;

class function TArrayUtils.FindIndex<T>(const A: array of T;
  const AConstraint: TConstraintEx<T>): Integer;
var
  Idx: Integer;
begin
  Result := -1;
  for Idx := 0 to Pred(Length(A)) do
    if AConstraint(A[Idx], Idx, A) then
      Exit(Idx);
end;

class function TArrayUtils.FindLastDef<T>(const A: array of T;
  const AConstraint: TConstraint<T>; const ADefault: T): T;
begin
  if not TryFindLast<T>(A, AConstraint, Result) then
    Result := ADefault;
end;

class function TArrayUtils.FindLastDef<T>(const A: array of T;
  const AConstraint: TConstraintEx<T>; const ADefault: T): T;
begin
  if not TryFindLast<T>(A, AConstraint, Result) then
    Result := ADefault;
end;

class function TArrayUtils.FindLastIndex<T>(const A: array of T;
  const AConstraint: TConstraint<T>): Integer;
var
  Idx: Integer;
begin
  Result := -1;
  for Idx := Pred(Length(A)) downto 0 do
    if AConstraint(A[Idx]) then
      Exit(Idx);
end;

class function TArrayUtils.FindLastIndex<T>(const A: array of T;
  const AConstraint: TConstraintEx<T>): Integer;
var
  Idx: Integer;
begin
  Result := -1;
  for Idx := Pred(Length(A)) downto 0 do
    if AConstraint(A[Idx], Idx, A) then
      Exit(Idx);
end;

class function TArrayUtils.First<T>(const A: array of T): T;
begin
  Assert(Length(A) > 0);
  Result := A[0];
end;

class procedure TArrayUtils.ForEach<T>(const A: array of T;
  const ACallback: TCallback<T>);
var
  Elem: T;
begin
  for Elem in A do
    ACallback(Elem);
end;

class procedure TArrayUtils.ForEach<T>(const A: array of T;
  const ACallback: TCallbackEx<T>);
var
  Idx: Integer;
begin
  for Idx := 0 to Pred(Length(A)) do
    ACallback(A[Idx], Idx, A);
end;

class function TArrayUtils.IndexOf<T>(const AItem: T; const A: array of T;
  const AEqualityComparer: IEqualityComparer<T>): Integer;
begin
  Result := FindIndex<T>(
    A,
    function (const AElem: T): Boolean
    begin
      Result := AEqualityComparer.Equals(AElem, AItem);
    end
  );
end;

class function TArrayUtils.IndexOf<T>(const AItem: T; const A: array of T;
  const AEqualityComparer: TEqualityComparison<T>): Integer;
begin
  Result := FindIndex<T>(
    A,
    function (const AElem: T): Boolean
    begin
      Result := AEqualityComparer(AElem, AItem);
    end
  );
end;

class function TArrayUtils.IndexOf<T>(const AItem: T; const A: array of T):
  Integer;
begin
  Result := FindIndex<T>(
    A,
    function (const AElem: T): Boolean
    begin
      Result := TEqualityComparer<T>.Default.Equals(AElem, AItem);
    end
  );
end;

class function TArrayUtils.IndicesOf<T>(const AItem: T; const A: array of T;
  const AEqualityComparer: TEqualityComparison<T>): TArray<Integer>;
begin
  Result := FindAllIndices<T>(
    A,
    function (const AElem: T): Boolean
    begin
      Result := AEqualityComparer(AElem, AItem);
    end
  );
end;

class function TArrayUtils.IndicesOf<T>(const AItem: T; const A: array of T;
  const AEqualityComparer: IEqualityComparer<T>): TArray<Integer>;
begin
  Result := FindAllIndices<T>(
    A,
    function (const AElem: T): Boolean
    begin
      Result := AEqualityComparer.Equals(AElem, AItem);
    end
  );
end;

class function TArrayUtils.IndicesOf<T>(const AItem: T;
  const A: array of T): TArray<Integer>;
begin
  Result := FindAllIndices<T>(
    A,
    function (const AElem: T): Boolean
    begin
      Result := TEqualityComparer<T>.Default.Equals(AElem, AItem);
    end
  );
end;

class procedure TArrayUtils.Insert<T>(var A: TArray<T>; AValue: T;
  AIndex: Integer);
var
  OrigLengthOfA: Integer;
begin
  OrigLengthOfA := Length(A);
  ClampInRange(AIndex, 0, OrigLengthOfA);
  SetLength(A, OrigLengthOfA + 1);
  ShuffleUp<T>(A, AIndex, Pred(OrigLengthOfA), 1);
  A[AIndex] := AValue;
end;

class procedure TArrayUtils.Insert<T>(var A: TArray<T>;
  const AValues: array of T; AIndex: Integer);
var
  OrigLengthOfA: Integer;
begin
  OrigLengthOfA := Length(A);
  ClampInRange(AIndex, 0, OrigLengthOfA);
  if Length(AValues) = 0 then
    Exit;
  SetLength(A, OrigLengthOfA + Length(AValues));
  ShuffleUp<T>(A, AIndex, Pred(OrigLengthOfA), Length(AValues));
  CopyIntoArray<T>(A, AIndex, AValues);
end;

class function TArrayUtils.IntMax(const A, B: Integer): Integer;
begin
  {$IFDEF SupportsUnitScopeNames}
  Result := System.Math.Max(A, B);
  {$ELSE}
  Result := Math.Max(A, B);
  {$ENDIF}
end;

class function TArrayUtils.IntMin(const A, B: Integer): Integer;
begin
  {$IFDEF SupportsUnitScopeNames}
  Result := System.Math.Min(A, B);
  {$ELSE}
  Result := Math.Min(A, B);
  {$ENDIF}
end;

class function TArrayUtils.Last<T>(const A: array of T): T;
begin
  Assert(Length(A) > 0);
  Result := A[Pred(Length(A))];
end;

class function TArrayUtils.LastIndexOf<T>(const AItem: T; const A: array of T;
  const AEqualityComparer: TEqualityComparison<T>): Integer;
begin
  Result := FindLastIndex<T>(
    A,
    function (const AElem: T): Boolean
    begin
      Result := AEqualityComparer(AItem, AElem);
    end
  );
end;

class function TArrayUtils.LastIndexOf<T>(const AItem: T; const A: array of T;
  const AEqualityComparer: IEqualityComparer<T>): Integer;
begin
  Result := FindLastIndex<T>(
    A,
    function (const AElem: T): Boolean
    begin
      Result := AEqualityComparer.Equals(AItem, AElem);
    end
  );
end;

class function TArrayUtils.LastIndexOf<T>(const AItem: T;
  const A: array of T): Integer;
begin
  Result := FindLastIndex<T>(
    A,
    function (const AElem: T): Boolean
    begin
      Result := TEqualityComparer<T>.Default.Equals(AItem, AElem);
    end
  );
end;

class function TArrayUtils.Max<T>(const A: array of T;
  const AComparer: TComparison<T>): T;
begin
  Assert(Length(A) > 0);
  Result := Reduce<T>(
    A,
    function (const AAccumulator, ACurrent: T): T
    begin
      if AComparer(ACurrent, AAccumulator) > 0 then
        Result := ACurrent
      else
        Result := AAccumulator;
    end
  );
end;

class function TArrayUtils.Max<T>(const A: array of T;
  const AComparer: IComparer<T>): T;
begin
  Result := Max<T>(
    A,
    function (const L, R: T): Integer
    begin
      Result := AComparer.Compare(L, R);
    end
  );
end;

class function TArrayUtils.Max<T>(const A: array of T): T;
begin
  Result := Max<T>(
    A,
    function (const L, R: T): Integer
    begin
      Result := TComparer<T>.Default.Compare(L, R);
    end
  );
end;

class function TArrayUtils.Min<T>(const A: array of T;
  const AComparer: TComparison<T>): T;
begin
  Assert(Length(A) > 0);
  Result := Reduce<T>(
    A,
    function (const AAccumulator, ACurrent: T): T
    begin
      if AComparer(ACurrent, AAccumulator) < 0 then
        Result := ACurrent
      else
        Result := AAccumulator;
    end
  );
end;

class function TArrayUtils.Min<T>(const A: array of T;
  const AComparer: IComparer<T>): T;
begin
  Result := Min<T>(
    A,
    function (const L, R: T): Integer
    begin
      Result := AComparer.Compare(L, R);
    end
  );
end;

class function TArrayUtils.Min<T>(const A: array of T): T;
begin
  Result := Min<T>(
    A,
    function (const L, R: T): Integer
    begin
      Result := TComparer<T>.Default.Compare(L, R);
    end
  );
end;

class procedure TArrayUtils.MinMax<T>(const A: array of T;
  const AComparer: TComparison<T>; out AMinValue, AMaxValue: T);
var
  Idx: Integer;
begin
  Assert(Length(A) > 0);
  AMinValue := A[0];
  AMaxValue := A[0];
  for Idx := 1 to Pred(Length(A)) do
  begin
    if AComparer(A[Idx], AMinValue) < 0 then
      AMinValue := A[Idx]
    else if AComparer(A[Idx], AMaxValue) > 0 then
      AMaxValue := A[Idx];
  end;
end;

class procedure TArrayUtils.MinMax<T>(const A: array of T;
  AComparer: IComparer<T>; out AMinValue, AMaxValue: T);
begin
  MinMax<T>(
    A,
    function (const L, R: T): Integer
    begin
      Result := AComparer.Compare(L, R);
    end,
    AMinValue,
    AMaxValue
  );
end;

class procedure TArrayUtils.MinMax<T>(const A: array of T; out AMinValue,
  AMaxValue: T);
begin
  MinMax<T>(
    A,
    function (const L, R: T): Integer
    begin
      Result := TComparer<T>.Default.Compare(L, R);
    end,
    AMinValue,
    AMaxValue
  );
end;

class procedure TArrayUtils.NormaliseArrayRange(const AArrayLength: Integer;
  var AStartIndex, AEndIndex: Integer; out ARangeLength: Integer);
begin
  AStartIndex := IntMax(AStartIndex, 0);
  AEndIndex := IntMin(AEndIndex, Pred(AArrayLength));
  ARangeLength := IntMax(AEndIndex - AStartIndex + 1, 0);
end;

class function TArrayUtils.OccurrencesOf<T>(const AItem: T; const A: array of T;
  const AEqualityComparer: TEqualityComparison<T>): Integer;
var
  Elem: T;
begin
  Result := 0;
  for Elem in A do
    if AEqualityComparer(Elem, AItem) then
      Inc(Result);
end;

class function TArrayUtils.OccurrencesOf<T>(const AItem: T; const A: array of T;
  const AEqualityComparer: IEqualityComparer<T>): Integer;
begin
  Result := OccurrencesOf<T>(
    AItem,
    A,
    function (const L, R: T): Boolean
    begin
      Result := AEqualityComparer.Equals(L, R);
    end
  );
end;

class function TArrayUtils.OccurrencesOf<T>(const AItem: T;
  const A: array of T): Integer;
begin
  Result := OccurrencesOf<T>(
    AItem,
    A,
    function (const L, R: T): Boolean
    begin
      Result := TEqualityComparer<T>.Default.Equals(L, R);
    end
  );
end;

class function TArrayUtils.Pick<T>(const A: array of T;
  const AIndices: array of Integer): TArray<T>;
var
  PickList: TList<T>;
  Idx: Integer;
begin
  PickList := TList<T>.Create;
  try
    for Idx in CleanIndices(AIndices, Length(A), False) do
      PickList.Add(A[Idx]);
    Result := PickList.ToArray;
  finally
    PickList.Free;
  end;
end;

class function TArrayUtils.Pop<T>(var A: TArray<T>): T;
begin
  Assert(Length(A) > 0);
  Result := A[High(A)];
  SetLength(A, Pred(Length(A)));
end;

class procedure TArrayUtils.PopAndFree<T>(var A: TArray<T>);
begin
  Assert(Length(A) > 0);
  Pop<T>(A).Free;
end;

class procedure TArrayUtils.PopAndRelease<T>(var A: TArray<T>;
  const AReleaser: TCallback<T>);
begin
  Assert(Length(A) > 0);
  AReleaser(Pop<T>(A));
end;

class procedure TArrayUtils.Push<T>(var A: TArray<T>; const AValue: T);
begin
  SetLength(A, Length(A) + 1);
  A[Pred(Length(A))] := AValue;
end;

class function TArrayUtils.Reduce<T>(const A: array of T;
  const AReducer: TReducer<T>): T;
var
  Idx: Integer;
begin
  Assert(Length(A) > 0);
  Result := A[0];
  for Idx := 1 to Pred(Length(A)) do
    Result := AReducer(Result, A[Idx]);
end;

class function TArrayUtils.Reduce<T>(const A: array of T;
  const AReducer: TReducer<T>; const AInitialValue: T): T;
var
  Elem: T;
begin
  Result := AInitialValue;
  for Elem in A do
    Result := AReducer(Result, Elem);
end;

class function TArrayUtils.Reduce<T>(const A: array of T;
  const AReducer: TReducerEx<T>; const AInitialValue: T): T;
var
  Idx: Integer;
begin
  Result := AInitialValue;
  for Idx := 0 to Pred(Length(A)) do
    Result := AReducer(Result, A[Idx], Idx, A);
end;

class function TArrayUtils.Reduce<TIn, TOut>(const A: array of TIn;
  const AReducer: TReducer<TIn, TOut>; const AInitialValue: TOut): TOut;
var
  Elem: TIn;
begin
  Result := AInitialValue;
  for Elem in A do
    Result := AReducer(Result, Elem);
end;

class function TArrayUtils.Reduce<TIn, TOut>(const A: array of TIn;
  const AReducer: TReducerEx<TIn, TOut>; const AInitialValue: TOut): TOut;
var
  Idx: Integer;
begin
  Result := AInitialValue;
  for Idx := 0 to Pred(Length(A)) do
    Result := AReducer(Result, A[Idx], Idx, A);
end;

class procedure TArrayUtils.Reverse<T>(var A: array of T);
var
  LIdx, RIdx: Integer;
  Temp: T;
begin
  LIdx := 0;
  RIdx := Pred(Length(A));
  while LIdx < RIdx do
  begin
    // swap elements at "opposite" indices LIdx & RIdx
    // we never touch the middle element in odd length arrays
    Temp := A[LIdx];
    A[LIdx] := A[RIdx];
    A[RIdx] := Temp;
    // next pair of elements
    Inc(LIdx);
    Dec(RIdx);
  end;
end;

class function TArrayUtils.Shift<T>(var A: TArray<T>): T;
begin
  Assert(Length(A) > 0);
  Result := A[0];
  ShuffleDown<T>(A, 0, Pred(High(A)), 1);
  SetLength(A, Pred(Length(A)));
end;

class procedure TArrayUtils.ShiftAndFree<T>(var A: TArray<T>);
begin
  Assert(Length(A) > 0);
  Shift<T>(A).Free;
end;

class procedure TArrayUtils.ShiftAndRelease<T>(var A: TArray<T>;
  const AReleaser: TCallback<T>);
begin
  Assert(Length(A) > 0);
  AReleaser(Shift<T>(A));
end;

class procedure TArrayUtils.ShuffleDown<T>(var A: TArray<T>;
  const ARangeLo, ARangeHi, AOffset: Integer);
var
  Idx: Integer;
begin
  for Idx := ARangeLo to ARangeHi do
    A[Idx] := A[Idx + AOffset];
end;

class procedure TArrayUtils.ShuffleUp<T>(var A: TArray<T>; const ARangeLo,
  ARangeHi, AOffset: Integer);
var
  Idx: Integer;
begin
  for Idx := ARangeHi downto ARangeLo do
    A[Idx + AOffset] := A[Idx];
end;

class function TArrayUtils.Slice<T>(const A: array of T;
  AStartIndex: Integer): TArray<T>;
begin
  Result := Slice<T>(A, AStartIndex, Pred(Length(A)));
end;

class function TArrayUtils.Slice<T>(const A: array of T; AStartIndex,
  AEndIndex: Integer): TArray<T>;
var
  Idx, ResLength: Integer;
begin
  NormaliseArrayRange(Length(A), AStartIndex, AEndIndex, ResLength);
  SetLength(Result, ResLength);
  if ResLength = 0 then
    Exit;
  for Idx := AStartIndex to AEndIndex do
    Result[Idx - AStartIndex] := A[Idx];
end;

class function TArrayUtils.Some<T>(const A: array of T;
  const AConstraint: TConstraint<T>): Boolean;
var
  Elem: T;
begin
  Assert(Length(A) > 0); // meaningless for empty array
  Result := False;
  for Elem in A do
    if AConstraint(Elem) then
      Exit(True);
end;

class function TArrayUtils.Some<T>(const A: array of T;
  const AConstraint: TConstraintEx<T>): Boolean;
var
  Idx: Integer;
begin
  Assert(Length(A) > 0); // meaningless for empty array
  Result := False;
  for Idx := 0 to Pred(Length(A)) do
    if AConstraint(A[Idx], Idx, A) then
      Exit(True);
end;

class procedure TArrayUtils.Sort<T>(var A: array of T);
var
  Comparer: IComparer<T>;
begin
  // required to avoid compiler error
  Comparer := TComparer<T>.Default;
  Sort<T>(A, Comparer);
end;

class procedure TArrayUtils.Sort<T>(var A: array of T;
  const AComparer: IComparer<T>);
begin
  TArray.Sort<T>(A, AComparer);
end;

class procedure TArrayUtils.Sort<T>(var A: array of T;
  const AComparer: TComparison<T>);
var
  Comparer: IComparer<T>;
begin
  // assignment required here to prevent memory leak
  Comparer := TDelegatedComparer<T>.Create(AComparer);
  TArray.Sort<T>(A, Comparer);
end;

class function TArrayUtils.Transform<TIn, TOut>(const A: array of TIn;
  const ATransformFunc: TTransformerEx<TIn, TOut>): TArray<TOut>;
var
  Idx: Integer;
begin
  SetLength(Result, Length(A));
  for Idx := 0 to Pred(Length(A)) do
    Result[Idx] := ATransformFunc(A[Idx], Idx, A);
end;

class function TArrayUtils.TryFind<T>(const A: array of T;
  const AConstraint: TConstraintEx<T>; out AItem: T): Boolean;
var
  Idx: Integer;
begin
  Idx := FindIndex<T>(A, AConstraint);
  if Idx = -1 then
    Exit(False);
  AItem := A[Idx];
  Result := True;
end;

class function TArrayUtils.TryFind<T>(const A: array of T;
  const AConstraint: TConstraint<T>; out AItem: T): Boolean;
var
  Idx: Integer;
begin
  Idx := FindIndex<T>(A, AConstraint);
  if Idx = -1 then
    Exit(False);
  AItem := A[Idx];
  Result := True;
end;

class function TArrayUtils.TryFindLast<T>(const A: array of T;
  const AConstraint: TConstraintEx<T>; out AItem: T): Boolean;
var
  Idx: Integer;
begin
  Idx := FindLastIndex<T>(A, AConstraint);
  if Idx = -1 then
    Exit(False);
  AItem := A[Idx];
  Result := True;
end;

class function TArrayUtils.TryFindLast<T>(const A: array of T;
  const AConstraint: TConstraint<T>; out AItem: T): Boolean;
var
  Idx: Integer;
begin
  Idx := FindLastIndex<T>(A, AConstraint);
  if Idx = -1 then
    Exit(False);
  AItem := A[Idx];
  Result := True;
end;

class function TArrayUtils.Transform<TIn, TOut>(const A: array of TIn;
  const ATransformFunc: TTransformer<TIn, TOut>): TArray<TOut>;
var
  Idx: Integer;
begin
  SetLength(Result, Length(A));
  for Idx := 0 to Pred(Length(A)) do
    Result[Idx] := ATransformFunc(A[Idx]);
end;

class procedure TArrayUtils.UnShift<T>(var A: TArray<T>; const AValue: T);
begin
  SetLength(A, Length(A) + 1);
  ShuffleUp<T>(A, 0, Length(A) - 2, 1);
  A[0] := AValue;
end;

end.

