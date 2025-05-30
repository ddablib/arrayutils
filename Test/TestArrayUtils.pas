{
 * Delphi DUnit test cases for the DelphiDabbler.Lib.ArrayUtils unit.
 *
 * These test cases were created with Delphi 12 targetted at Win32 and Win64.
 * The project has been checked with Delphi XE targetted at Win32.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit TestArrayUtils;

// Delphi XE or later is required to compile
// For Delphi XE2 and later we use scoped unit names
{$UNDEF CanCompile}
{$UNDEF SupportsUnitScopeNames}
{$UNDEF HasSystemHashUnit}
{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 24.0} // Delphi XE3 and later
    {$LEGACYIFEND ON}  // NOTE: this must come before all $IFEND directives
  {$IFEND}
  {$IF CompilerVersion >= 29.0} // Delphi XE8 and later
    {$DEFINE HasSystemHashUnit}
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
  TestFramework
  , DelphiDabbler.Lib.ArrayUtils
  {$IFDEF SupportsUnitScopeNames}
  , System.Generics.Defaults
  , System.Classes
  , System.Types
  {$IFDEF HasSystemHashUnit}
  , System.Hash
  {$ENDIF}
  {$ELSE}
  , Generics.Defaults
  , Classes
  , Types
  {$ENDIF}
  ;

type

  TIntegerComparer = class(TInterfacedObject, IComparer<Integer>, IEqualityComparer<Integer>)
  protected
    function Compare(const Left, Right: Integer): Integer;
    function Equals(const Left, Right: Integer): Boolean; reintroduce;
    function GetHashCode(const Value: Integer): Integer; reintroduce;
  end;

  TStringComparer = class(TInterfacedObject, IComparer<string>, IEqualityComparer<string>)
  protected
    function Compare(const Left, Right: string): Integer;
    function Equals(const Left, Right: string): Boolean; reintroduce;
    function GetHashCode(const Value: string): Integer; reintroduce;
  end;

  TTextComparer = class(TInterfacedObject, IComparer<string>, IEqualityComparer<string>)
  protected
    function Compare(const Left, Right: string): Integer;
    function Equals(const Left, Right: string): Boolean; reintroduce;
    function GetHashCode(const Value: string): Integer; reintroduce;
  end;

  TPointComparer = class(TInterfacedObject, IComparer<TPoint>, IEqualityComparer<TPoint>)
  public
    function Compare(const Left, Right: TPoint): Integer;
    function Equals(const Left, Right: TPoint): Boolean; reintroduce;
    function GetHashCode(const Value: TPoint): Integer; reintroduce;
  end;


  // Test case for TArrayUtils
  TestTArrayUtils = class(TTestCase)
  strict private

    type
      TTestObj = class(TObject)
      strict private
        class var
          fInstanceCount: Cardinal;
        var
          fA: string;
          fB: TStrings;
        procedure SetB(const SL: TStrings);
      public
        class constructor Create;
        constructor Create(const S: string; const Strs: TArray<string>);
        destructor Destroy; override;
        function Equals(Other: TTestObj): Boolean; reintroduce;
        function Compare(Other: TTestObj): Integer;
        function Clone: TTestObj;
        property A: string read fA write fA;
        property B: TStrings read fB write SetB;
        class property InstanceCount: Cardinal read fInstanceCount;
      end;

      TTestObjComparer = class(TInterfacedObject, IComparer<TTestObj>, IEqualityComparer<TTestObj>)
      public
        function Compare(const Left, Right: TTestObj): Integer;
        function Equals(const Left, Right: TTestObj): Boolean; reintroduce;
        function GetHashCode(const Value: TTestObj): Integer; reintroduce;
      end;

      TTestResource = record
      strict private
        class var
          fInstanceCount: Cardinal;
        var
          fS: string;
          fI: Integer;
      public
        class constructor Create;
        constructor Create(const S: string; const I: Integer);
        procedure Release;
        property S: string read fS write fS;
        property I: Integer read fI write fI;
        class property InstanceCount: Cardinal read fInstanceCount;
      end;

    var
      IA0, IA0Dup, IA1, IA2, IA2Dup, IA2Rev, IA3, IA3Rev, IA4, IA5, IA6, IA7: TArray<Integer>;
      SA0, SA1five, SA1two, SA2, SA2Dup, SA2DupIgnoreCase, SA2Rev, SA3, SA4, SA5, SA6, SA7: TArray<string>;
      PA0, PA1, PA2, PA2short, PA2dup, PA3, PA4: TArray<TPoint>;

      O1, O2, O2Dup, O3, O4, O5: TTestObj;
      OA0, OA1, OA2, OA2Dup, OA2Rev, OA3, OATwoPeeks: TArray<TTestObj>;

      IntCompareFn: TComparison<Integer>;
      StrCompareStrFn: TComparison<string>;
      StrCompareTextFn: TComparison<string>;
      PointCompareFn: TComparison<TPoint>;
      TestObjCompareFn: TComparison<TTestObj>;

      IntEqualsFn: TEqualityComparison<Integer>;
      StrEqualsStrFn: TEqualityComparison<string>;
      StrEqualsTextFn: TEqualityComparison<string>;
      PointEqualsFn: TEqualityComparison<TPoint>;
      TestObjEqualsFn: TEqualityComparison<TTestObj>;
      ExtendedEqualsFn: TEqualityComparison<Extended>;

      IntegerComparer: IComparer<Integer>;
      StringComparer: IComparer<string>;
      TextComparer: IComparer<string>;
      PointComparer: IComparer<TPoint>;
      TestObjComparer: IComparer<TTestObj>;

      IntegerEqualityComparer: IEqualityComparer<Integer>;
      StringEqualityComparer: IEqualityComparer<string>;
      TextEqualityComparer: IEqualityComparer<string>;
      PointEqualityComparer: IEqualityComparer<TPoint>;
      TestObjEqualityComparer: IEqualityComparer<TTestObj>;

      ObjCloner: TArrayUtils.TCloner<TTestObj>;

    const
      Pp1p3: TPoint = (X: 1; Y: 3);
      Pp1p3Dup: TPoint = (X: 1; Y: 3);
      Pm1p5: TPoint = (X: -1; Y: 5);
      Pp12m12: TPoint = (X: 12; Y: -12);
      Pm8m9: TPoint = (X: -8; Y: -9);
      Pp12p5: TPoint = (X: 12; Y: 5);
      Pmissing: TPoint = (X: 42; Y: 42);

    class function DistFromOrigin(const P: TPoint): Extended;
    class procedure FreeTestObjs(const A: array of TTestObj);
    class procedure ReleaseTestResources(const A: array of TTestResource);

    procedure EqualStart_ComparerFunc_Overload_AssertionFailure;
    procedure EqualStart_ComparerObj_Overload_AssertionFailure;
    procedure EqualStart_NilComparer_Overload_AssertionFailure;

    procedure First_AssertionFailure;

    procedure Last_AssertionFailure;

    procedure Max_ComparerFunc_Overload_AssertionFailure;
    procedure Max_ComparerObj_Overload_AssertionFailure;
    procedure Max_NilComparer_Overload_AssertionFailure;

    procedure Min_ComparerFunc_Overload_AssertionFailure;
    procedure Min_ComparerObj_Overload_AssertionFailure;
    procedure Min_NilComparer_Overload_AssertionFailure;

    procedure MinMax_ComparerFunc_Overload_AssertionFailure;
    procedure MinMax_ComparerObj_Overload_AssertionFailure;
    procedure MinMax_NilComparer_Overload_AssertionFailure;

    procedure Every_SimpleCallback_Overload_AssertionFailure;
    procedure Every_ExtendedCallback_Overload_AssertionFailure;

    procedure Some_SimpleCallback_Overload_AssertionFailure;
    procedure Some_ExtendedCallback_Overload_AssertionFailure;

    procedure Reduce_SimpleCallback_Overload_AssertionFailure;

    procedure Pop_AssertionFailure;

    procedure PopAndRelease_AssertionFailure;

    procedure PopAndFree_AssertionFailure;

    procedure Shift_AssertionFailure;

    procedure ShiftAndRelease_AssertionFailure;

    procedure ShiftAndFree_AssertionFailure;

  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    // Equal<T> is used in some other tests and assumed to work: so
    // we test it first
    procedure TestEqual_ComparerFunc_Overload;
    procedure TestEqual_ComparerObj_Overload;
    procedure TestEqual_NilComparer_Overload;

    procedure TestEqualStart_ComparerFunc_Overload;
    procedure TestEqualStart_ComparerObj_Overload;
    procedure TestEqualStart_NilComparer_Overload;

    procedure TestDelete_SingleIndex_Overload;
    procedure TestDelete_MultipleIndices_Overload;

    // DeleteRange<T> is used in some later tests
    procedure TestDeleteRange_SingleIdx_Overload;
    procedure TestDeleteRange_DoubleIdx_Overload;

    procedure TestInsert_SingleElem_Overload;
    procedure TestInsert_Array_Overload;

    procedure TestCompare_ComparerFunc_Overload;
    procedure TestCompare_ComparerObj_Overload;
    procedure TestCompare_NilComparer_Overload;

    procedure TestFirst;

    procedure TestLast;

    procedure TestCopy_Shallow_Overload;
    procedure TestCopy_Deep_Overload;

    procedure TestConcat;

    // Slice<T> is used in some later tests
    procedure TestSlice_SingleIdx_Overload;
    procedure TestSlice_DoubleIdx_Overload;

    procedure TestPick;

    // Chop<T> requires Slice<T> and DeleteRange<T>
    procedure TestChop_SingleIdx_Overload;
    procedure TestChop_DoubleIdx_Overload;

    procedure TestIndexOf_ComparerFunc_Overload;
    procedure TestIndexOf_ComparerObj_Overload;
    procedure TestIndexOf_NilComparer_Overload;

    procedure TestLastIndexOf_ComparerFunc_Overload;
    procedure TestLastIndexOf_ComparerObj_Overload;
    procedure TestLastIndexOf_NilComparer_Overload;

    procedure TestPop;

    procedure TestPush;

    procedure TestShift;

    procedure TestUnShift;

    // IndicesOf<T> requires Push<T>
    procedure TestIndicesOf_ComparerFunc_Overload;
    procedure TestIndicesOf_ComparerObj_Overload;
    procedure TestIndicesOf_NilComparer_Overload;

    procedure TestContains_ComparerFunc_Overload;
    procedure TestContains_ComparerObj_Overload;
    procedure TestContains_NilComparer_Overload;

    procedure TestOccurrencesOf_ComparerFunc_Overload;
    procedure TestOccurrencesOf_ComparerObj_Overload;
    procedure TestOccurrencesOf_NilComparer_Overload;

    procedure TestTryFind_SimpleCallback_Overload;
    procedure TestTryFind_ExtendedCallback_Overload;

    procedure TestTryFindLast_SimpleCallback_Overload;
    procedure TestTryFindLast_ExtendedCallback_Overload;

    procedure TestFindAll_SimpleCallback_Overload;
    // Test calls IndexOf<T>
    procedure TestFindAll_ExtendedCallback_Overload;

    procedure TestFindIndex_SimpleCallback_Overload;
    procedure TestFindIndex_ExtendedCallback_Overload;

    procedure TestFindLastIndex_SimpleCallback_Overload;
    procedure TestFindLastIndex_ExtendedCallback_Overload;

    procedure TestFindAllIndices_SimpleCallback_Overload;
    // Test calls IndexOf<T>
    procedure TestFindAllIndices_ExtendedCallback_Overload;

    procedure TestFindDef__SimpleCallback_Overload;
    procedure TestFindDef__ExtendedCallback_Overload;

    procedure TestFindLastDef__SimpleCallback_Overload;
    procedure TestFindLastDef__ExtendedCallback_Overload;

    procedure TestReverse;

    procedure TestCopyReversed;

    procedure TestReduce_SimpleCallback_Overload;
    procedure TestReduce_InitValueAndSimpleCallback_OneType_Overload;
    procedure TestReduce_InitValueAndSimpleCallback_TwoTypes_Overload;
    procedure TestReduce_InitValueAndExtendedCallback_OneType_Overload;
    // Test calls IndexOf<T>
    procedure TestReduce_InitValueAndExtendedCallback_TwoTypes_Overload;

    // Max<T> requires Reduce<T>
    procedure TestMax_ComparerFunc_Overload;
    procedure TestMax_ComparerObj_Overload;
    procedure TestMax_NilComparer_Overload;

    // Min<T> requires Reduce<T>
    procedure TestMin_ComparerFunc_Overload;
    procedure TestMin_ComparerObj_Overload;
    procedure TestMin_NilComparer_Overload;

    procedure TestMinMax_ComparerFunc_Overload;
    procedure TestMinMax_ComparerObj_Overload;
    procedure TestMinMax_NilComparer_Overload;

    procedure TestEvery_SimpleCallback_Overload;
    procedure TestEvery_ExtendedCallback_Overload;

    procedure TestSome_SimpleCallback_Overload;
    procedure TestSome_ExtendedCallback_Overload;

    procedure TestForEach_SimpleCallback_Overload;
    procedure TestForEach_ExtendedCallback_Overload;

    procedure TestTransform_SimpleCallback_Overload;
    procedure TestTransform_ExtendedCallback_Overload;

    procedure TestSort_ComparerFunc_Overload;
    procedure TestSort_ComparerObj_Overload;
    procedure TestSort_NilComparer_Overload;

    // CopySorted<T> requires Sort<T>
    procedure TestCopySorted_ComparerFunc_Overload;
    procedure TestCopySorted_ComparerObj_Overload;
    procedure TestCopySorted_NilComparer_Overload;

    // DeDup<T> requires Contains<T> and Push<T>, so test after both
    procedure TestDeDup_ComparerFunc_Overload;
    procedure TestDeDup_ComparerObj_Overload;
    procedure TestDeDup_NilComparer_Overload;

    procedure TestDeleteAndRelease_SingleIndex_Overload;
    procedure TestDeleteAndRelease_MultipleIndices_Overload;

    procedure TestDeleteAndReleaseRange_SingleIdx_Overload;
    procedure TestDeleteAndReleaseRange_DoubleIdx_Overload;

    procedure TestPopAndRelease;

    procedure TestShiftAndRelease;

    procedure TestDeleteAndFree_SingleIndex_Overload;
    procedure TestDeleteAndFree_MultipleIndices_Overload;

    procedure TestDeleteAndFreeRange_SingleIdx_Overload;
    procedure TestDeleteAndFreeRange_DoubleIdx_Overload;

    procedure TestPopAndFree;

    procedure TestShiftAndFree;

  end;

implementation

uses
  {$IFDEF SupportsUnitScopeNames}
  System.SysUtils
  , System.Math
  , System.Generics.Collections
  {$ELSE}
  SysUtils
  , Generics.Collections
  , Math
  {$ENDIF}
  ;


function StringHash(const S: string): Integer;
begin
  {$IFDEF HasSystemHashUnit}
  Result := THashBobJenkins.GetHashValue(PChar(S)^, SizeOf(Char) * Length(S), 0);
  {$ELSE}
  Result := BobJenkinsHash(PChar(S)^, SizeOf(Char) * Length(S), 0);
  {$ENDIF}
end;

{ TestTArrayUtils }

class function TestTArrayUtils.DistFromOrigin(const P: TPoint): Extended;
begin
  Result := Sqrt(Sqr(P.X) + Sqr(P.Y));
end;

procedure TestTArrayUtils.EqualStart_ComparerFunc_Overload_AssertionFailure;
begin
  TArrayUtils.EqualStart<Integer>(IA4, IA3, 0, IntEqualsFn);
end;

procedure TestTArrayUtils.EqualStart_ComparerObj_Overload_AssertionFailure;
begin
  TArrayUtils.EqualStart<string>(SA4, SA3, -42, TextEqualityComparer);
end;

procedure TestTArrayUtils.EqualStart_NilComparer_Overload_AssertionFailure;
begin
  TArrayUtils.EqualStart<string>(SA4, SA3, 0);
end;

procedure TestTArrayUtils.Every_ExtendedCallback_Overload_AssertionFailure;
begin
  TArrayUtils.Every<Integer>(
    IA0,
    function (const AElem: Integer; const AIndex: Integer;
      const A: array of Integer): Boolean
    begin
      Result := False;
    end
  );
end;

procedure TestTArrayUtils.Every_SimpleCallback_Overload_AssertionFailure;
begin
  TArrayUtils.Every<Integer>(
    IA0,
    function (const AElem: Integer): Boolean
    begin
      Result := False;
    end
  );
end;

procedure TestTArrayUtils.First_AssertionFailure;
begin
  TArrayUtils.First<Integer>(IA0);
end;

class procedure TestTArrayUtils.FreeTestObjs(const A: array of TTestObj);
var
  Elem: TTestObj;
begin
  for Elem in A do
    Elem.Free;
end;

procedure TestTArrayUtils.Last_AssertionFailure;
begin
  TArrayUtils.Last<string>(SA0);
end;

procedure TestTArrayUtils.Max_ComparerFunc_Overload_AssertionFailure;
begin
  TArrayUtils.Max<string>(SA0, StrCompareStrFn);
end;

procedure TestTArrayUtils.Max_ComparerObj_Overload_AssertionFailure;
begin
  TArrayUtils.Max<string>(SA0, StringComparer);
end;

procedure TestTArrayUtils.Max_NilComparer_Overload_AssertionFailure;
begin
  TArrayUtils.Max<TPoint>(PA0);
end;

procedure TestTArrayUtils.MinMax_ComparerFunc_Overload_AssertionFailure;
var
  Smallest, Largest: Integer;
begin
  TArrayUtils.MinMax<Integer>(IA0, IntCompareFn, Smallest, Largest);
end;

procedure TestTArrayUtils.MinMax_ComparerObj_Overload_AssertionFailure;
var
  Smallest, Largest: Integer;
begin
  TArrayUtils.MinMax<Integer>(IA0, IntegerComparer, Smallest, Largest);
end;

procedure TestTArrayUtils.MinMax_NilComparer_Overload_AssertionFailure;
var
  Smallest, Largest: Integer;
begin
  TArrayUtils.MinMax<Integer>(IA0, Smallest, Largest);
end;

procedure TestTArrayUtils.Min_ComparerFunc_Overload_AssertionFailure;
begin
  TArrayUtils.Min<string>(SA0, StrCompareStrFn);
end;

procedure TestTArrayUtils.Min_ComparerObj_Overload_AssertionFailure;
begin
  TArrayUtils.Max<Integer>(IA0, IntegerComparer);
end;

procedure TestTArrayUtils.Min_NilComparer_Overload_AssertionFailure;
begin
  TArrayUtils.Max<TPoint>(PA0);
end;

procedure TestTArrayUtils.PopAndFree_AssertionFailure;
begin
  TArrayUtils.PopAndFree<TTestObj>(OA0);
end;

procedure TestTArrayUtils.PopAndRelease_AssertionFailure;
var
  R: TArray<TTestResource>;
begin
  SetLength(R, 0);
  TArrayUtils.PopAndRelease<TTestResource>(
    R,
    procedure (const AElem: TTestResource) begin AElem.Release end
  );
end;

procedure TestTArrayUtils.Pop_AssertionFailure;
begin
  TArrayUtils.Pop<TPoint>(PA0);
end;

procedure TestTArrayUtils.Reduce_SimpleCallback_Overload_AssertionFailure;
begin
  TArrayUtils.Reduce<Integer>(
    IA0,
    function (const A, C: Integer): Integer
    begin
      Result := 0;
    end
  );
end;

class procedure TestTArrayUtils.ReleaseTestResources(
  const A: array of TTestResource);
var
  R: TTestResource;
begin
  for R in A do
    R.Release;
end;

procedure TestTArrayUtils.SetUp;
begin
  inherited;

  IA0 := TArray<Integer>.Create();
  IA0Dup := TArray<Integer>.Create();
  IA1 := TArray<Integer>.Create(7);
  IA2 := TArray<Integer>.Create(2, 4, 6, 8);
  IA2Dup := TArray<Integer>.Create(2, 4, 6, 8);
  IA2Rev := TArray<Integer>.Create(8, 6, 4, 2);
  IA3 := TArray<Integer>.Create(1, 3, 4, 6, 9);
  IA3Rev := TArray<Integer>.Create(9, 6, 4, 3, 1);
  IA4 := TArray<Integer>.Create(1, 3, 5, 7, 9);
  IA5 := TArray<Integer>.Create(0, 1, 2, 3, 4, 3, 2, 1, 0);
  IA6 := TArray<Integer>.Create(9, 9, 9, 8, 9, 9, 9);
  IA7 := TArray<Integer>.Create(1, 5, 6, 4, 3, 5, 8, 3, 2); // two peaks

  SA0 := TArray<string>.Create();
  SA1five := TArray<string>.Create('five');
  SA1two := TArray<string>.Create('two');
  SA2 := TArray<string>.Create('two', 'four', 'six', 'eight');
  SA2Dup := TArray<string>.Create('two', 'four', 'six', 'eight');
  SA2DupIgnoreCase := TArray<string>.Create('two', 'Four', 'SIX', 'Eight');
  SA2Rev := TArray<string>.Create('eight', 'six', 'four', 'two');
  SA3 := TArray<string>.Create('one', 'three', 'four', 'six', 'nine');
  SA4 := TArray<string>.Create('one', 'three', 'five', 'seven', 'nine');
  SA5 := TArray<string>.Create('one', 'two', 'one', 'two');
  SA6 := TArray<string>.Create('one', 'one', 'two', 'one', 'one', 'one');
  SA7 := TArray<string>.Create('one', 'three', 'five', 'three', 'two', 'one');

  PA0 := TArray<TPoint>.Create();
  PA1 := TArray<TPoint>.Create(Pp1p3);
  PA2 := TArray<TPoint>.Create(Pp1p3, Pp1p3Dup, Pm1p5, Pp12m12, Pm8m9, Pp12p5);
  PA2dup := TArray<TPoint>.Create(Pp1p3, Pp1p3Dup, Pm1p5, Pp12m12, Pm8m9, Pp12p5);
  PA2short := TArray<TPoint>.Create(Pp1p3, Pp1p3Dup, Pm1p5);
  PA3 := TArray<TPoint>.Create(Pp1p3, Pm1p5, Pm8m9, Pm8m9, Pm1p5, Pp1p3);
  PA4 := TArray<TPoint>.Create(Pp1p3, Pm8m9, Pm1p5);

  O1 := TTestObj.Create('a', TArray<string>.Create('a', 'b', 'c', 'd'));
  O2 := TTestObj.Create('b', TArray<string>.Create('b', 'c', 'd'));
  O2Dup := TTestObj.Create('b', TArray<string>.Create('b', 'c', 'd'));
  O3 := TTestObj.Create('c', TArray<string>.Create('d', 'c', 'b'));
  O4 := TTestObj.Create('@', TArray<string>.Create('@'));
  O5 := TTestObj.Create('d', TArray<string>.Create());

  OA0 := TArray<TTestObj>.Create();
  OA1 := TArray<TTestObj>.Create(O1);
  OA2  := TArray<TTestObj>.Create(O1, O2, O3, O4, O5);
  OA2Dup  := TArray<TTestObj>.Create(O1, O2Dup, O3, O4, O5);
  OA2Rev := TArray<TTestObj>.Create(O5, O4, O3, O2, O1);
  OA3  := TArray<TTestObj>.Create(O4, O5, O3, O2);
  OATwoPeeks := TArray<TTestObj>.Create(O1, O2, O3, O2, O3, O5, O2);

  IntCompareFn := function(const Left, Right: Integer): Integer
    begin
      Result := Left - Right;
    end;

  StrCompareStrFn := function (const Left, Right: string): Integer
    begin
      Result := CompareStr(Left, Right);
    end;

  StrCompareTextFn := function (const Left, Right: string): Integer
    begin
      Result := CompareStr(UpperCase(Left), UpperCase(Right));
    end;

  PointCompareFn := function (const Left, Right: TPoint): Integer
    begin
      Result := Left.X - Right.X;
      if Result = 0 then
        Result := Left.Y - Right.Y;
    end;

  TestObjCompareFn := function (const Left, Right: TTestObj): Integer
    begin
      Result := Left.Compare(Right);
    end;

  IntEqualsFn := function(const Left, Right: Integer): Boolean
    begin
      Result := Left = Right;
    end;

  StrEqualsStrFn := function(const Left, Right: string): Boolean
    begin
      Result := SameStr(Left, Right);
    end;

  StrEqualsTextFn := function(const Left, Right: string): Boolean
    begin
      Result := SameStr(UpperCase(Left), UpperCase(Right));
    end;

  PointEqualsFn := function (const Left, Right: TPoint): Boolean
    begin
      Result := (Left.X = Right.X) and (Left.Y = Right.Y);
    end;

  TestObjEqualsFn := function (const Left, Right: TTestObj): Boolean
    begin
      Result := Left.Equals(Right);
    end;

  ExtendedEqualsFn := function (const Left, Right: Extended): Boolean
    const
      Epsilon = 0.000001;
    begin
      Result := SameValue(Left, Right, Epsilon);
    end;

  IntegerComparer := TIntegerComparer.Create;
  StringComparer := TStringComparer.Create;
  TextComparer := TTextComparer.Create;
  PointComparer := TPointComparer.Create;
  TestObjComparer := TTestObjComparer.Create;

  IntegerEqualityComparer := TIntegerComparer.Create;
  StringEqualityComparer := TStringComparer.Create;
  TextEqualityComparer := TTextComparer.Create;
  PointEqualityComparer := TPointComparer.Create;
  TestObjEqualityComparer := TTestObjComparer.Create;

  ObjCloner := function (const O: TTestObj): TTestObj
    begin
      Result := O.Clone;
    end
end;

procedure TestTArrayUtils.ShiftAndFree_AssertionFailure;
begin
  TArrayUtils.ShiftAndFree<TTestObj>(OA0);
end;

procedure TestTArrayUtils.ShiftAndRelease_AssertionFailure;
var
  R: TArray<TTestResource>;
begin
  SetLength(R, 0);
  TArrayUtils.ShiftAndRelease<TTestResource>(
    R,
    procedure (const AElem: TTestResource) begin AElem.Release end
  );
end;

procedure TestTArrayUtils.Shift_AssertionFailure;
begin
  TArrayUtils.Shift<TPoint>(PA0);
end;

procedure TestTArrayUtils.Some_ExtendedCallback_Overload_AssertionFailure;
begin
  TArrayUtils.Every<string>(
    SA0,
    function (const AElem: string; const AIndex: Integer;
      const A: array of string): Boolean
    begin
      Result := False;
    end
  );
end;

procedure TestTArrayUtils.Some_SimpleCallback_Overload_AssertionFailure;
begin
  TArrayUtils.Every<string>(
    SA0,
    function (const AElem: string): Boolean
    begin
      Result := False;
    end
  );
end;

procedure TestTArrayUtils.TearDown;
begin
  O1.Free;
  O2.Free;
  O2Dup.Free;
  O3.Free;
  O4.Free;
  O5.Free;
  inherited;
end;

procedure TestTArrayUtils.TestChop_DoubleIdx_Overload;
var
  IA, ISlice, IExpectedSlice, IExpectedChopped: TArray<Integer>;
  SA, SSlice, SExpectedSlice, SExpectedChopped: TArray<string>;
  PA, PSlice, PExpectedSlice, PExpectedChopped: TArray<TPoint>;
  OA, OSlice, OExpectedSlice, OExpectedChopped: TArray<TTestObj>;
begin
  // chop from middle
  IA := Copy(IA5);
  ISlice := TArrayUtils.Chop<Integer>(IA, 2, 5);
  IExpectedSlice := TArray<Integer>.Create(2, 3, 4, 3);
  IExpectedChopped := TArray<Integer>.Create(0, 1, 2, 1, 0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedSlice, ISlice), 'I1a');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedChopped, IA), 'I1b');
  // chop from start
  IA := Copy(IA5);
  ISlice := TArrayUtils.Chop<Integer>(IA, 0, 5);
  IExpectedSlice := TArray<Integer>.Create(0, 1, 2, 3, 4, 3);
  IExpectedChopped := TArray<Integer>.Create(2, 1, 0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedSlice, ISlice), 'I2a');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedChopped, IA), 'I2b');
  // chop to end
  IA := Copy(IA5);
  ISlice := TArrayUtils.Chop<Integer>(IA, 5, 8);
  IExpectedSlice := TArray<Integer>.Create(3, 2, 1, 0);
  IExpectedChopped := TArray<Integer>.Create(0, 1, 2, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedSlice, ISlice), 'I3a');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedChopped, IA), 'I3b');
  // chop empty array
  IA := Copy(IA0);
  ISlice := TArrayUtils.Chop<Integer>(IA, 0, 0);
  IExpectedSlice := TArray<Integer>.Create();
  IExpectedChopped := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedSlice, ISlice), 'I4a');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedChopped, IA), 'I4b');
  // chop single elem array
  IA := Copy(IA1);
  ISlice := TArrayUtils.Chop<Integer>(IA, 0, 0);
  IExpectedSlice := TArray<Integer>.Create(7);
  IExpectedChopped := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedSlice, ISlice), 'I5a');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedChopped, IA), 'I5b');
  // chop with -1 start idx
  IA := Copy(IA5);
  ISlice := TArrayUtils.Chop<Integer>(IA, -1, 4);
  IExpectedSlice := TArray<Integer>.Create(0, 1, 2, 3, 4);
  IExpectedChopped := TArray<Integer>.Create(3, 2, 1, 0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedSlice, ISlice), 'I6a');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedChopped, IA), 'I6b');
  // chop with too high end idx
  IA := Copy(IA5);
  ISlice := TArrayUtils.Chop<Integer>(IA, 5, 12);
  IExpectedSlice := TArray<Integer>.Create(3, 2, 1, 0);
  IExpectedChopped := TArray<Integer>.Create(0, 1, 2, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedSlice, ISlice), 'I7a');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedChopped, IA), 'I7b');
  // chop with end idx = start idx
  IA := Copy(IA5);
  ISlice := TArrayUtils.Chop<Integer>(IA, 4, 4);
  IExpectedSlice := TArray<Integer>.Create(4);
  IExpectedChopped := TArray<Integer>.Create(0, 1, 2, 3, 3, 2, 1, 0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedSlice, ISlice), 'I8a');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedChopped, IA), 'I8b');
  // chop with end idx < start idx
  IA := Copy(IA5);
  ISlice := TArrayUtils.Chop<Integer>(IA, 4, 3);
  IExpectedSlice := TArray<Integer>.Create();
  IExpectedChopped := TArray<Integer>.Create(0, 1, 2, 3, 4, 3, 2, 1, 0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedSlice, ISlice), 'I9a');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedChopped, IA), 'I9b');
  // string version: chop from middle
  SA := Copy(SA3);
  SSlice := TArrayUtils.Chop<string>(SA, 2, 2);
  SExpectedSlice := TArray<string>.Create('four');
  SExpectedChopped := TArray<string>.Create('one', 'three', 'six', 'nine');
  CheckTrue(TArrayUtils.Equal<string>(SExpectedSlice, SSlice, StrEqualsStrFn), 'S1a');
  CheckTrue(TArrayUtils.Equal<string>(SExpectedChopped, SA, StrEqualsStrFn), 'S1b');
  // TPoint version: chop from beginning
  PA := Copy(PA4);
  PSlice := TArrayUtils.Chop<TPoint>(PA, 0, 1);
  PExpectedSlice := TArray<TPoint>.Create(Pp1p3, Pm8m9);
  PExpectedChopped := TArray<TPoint>.Create(Pm1p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpectedSlice, PSlice, PointEqualsFn), 'Pa');
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpectedChopped, PA, PointEqualsFn), 'Pb');
  // TTestObj version: chop from end
  OA := Copy(OA2);
  OSlice := TArrayUtils.Chop<TTestObj>(OA, 3, 4);
  OExpectedSlice := TArray<TTestObj>.Create(O4, O5);
  OExpectedChopped := TArray<TTestObj>.Create(O1, O2, O3);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpectedSlice, OSlice, TestObjEqualsFn), 'Oa');
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpectedChopped, OA, TestObjEqualsFn), 'Ob');
end;

procedure TestTArrayUtils.TestChop_SingleIdx_Overload;
var
  IA, ISlice, IExpectedSlice, IExpectedChopped: TArray<Integer>;
  SA, SSlice, SExpectedSlice, SExpectedChopped: TArray<string>;
  PA, PSlice, PExpectedSlice, PExpectedChopped: TArray<TPoint>;
  OA, OSlice, OExpectedSlice, OExpectedChopped: TArray<TTestObj>;
begin
  // chop starting from middle
  IA := Copy(IA5);
  ISlice := TArrayUtils.Chop<Integer>(IA, 5);
  IExpectedSlice := TArray<Integer>.Create(3, 2, 1, 0);
  IExpectedChopped := TArray<Integer>.Create(0, 1, 2, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedSlice, ISlice), 'I1a');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedChopped, IA), 'I1b');
  // chop starting from 1st elem
  IA := Copy(IA5);
  ISlice := TArrayUtils.Chop<Integer>(IA, 0);
  IExpectedSlice := TArray<Integer>.Create(0, 1, 2, 3, 4, 3, 2, 1, 0);
  IExpectedChopped := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedSlice, ISlice), 'I2a');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpectedChopped, IA), 'I2b');
  // chop starting from before 1st elem
  SA := Copy(SA3);
  SSlice := TArrayUtils.Chop<string>(SA, -1);
  SExpectedSlice := TArray<string>.Create('one', 'three', 'four', 'six', 'nine');
  SExpectedChopped := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(SExpectedSlice, SSlice, StrEqualsStrFn), 'S1a');
  CheckTrue(TArrayUtils.Equal<string>(SExpectedChopped, SA, StrEqualsStrFn), 'S1b');
  // chop starting at last elem
  SA := Copy(SA3);
  SSlice := TArrayUtils.Chop<string>(SA, 4);
  SExpectedSlice := TArray<string>.Create('nine');
  SExpectedChopped := TArray<string>.Create('one', 'three', 'four', 'six');
  CheckTrue(TArrayUtils.Equal<string>(SExpectedSlice, SSlice, StrEqualsStrFn), 'S2a');
  CheckTrue(TArrayUtils.Equal<string>(SExpectedChopped, SA, StrEqualsStrFn), 'S2b');
  // chop starting after last elem
  PA := Copy(PA4);
  PSlice := TArrayUtils.Chop<TPoint>(PA, 12);
  PExpectedSlice := TArray<TPoint>.Create();
  PExpectedChopped := TArray<TPoint>.Create(Pp1p3, Pm8m9, Pm1p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpectedSlice, PSlice, PointEqualsFn), 'P1a');
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpectedChopped, PA, PointEqualsFn), 'P1b');
  // chop from empty array
  PA := Copy(PA0);
  PSlice := TArrayUtils.Chop<TPoint>(PA, 0);
  PExpectedSlice := TArray<TPoint>.Create();
  PExpectedChopped := TArray<TPoint>.Create();
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpectedSlice, PSlice, PointEqualsFn), 'P2a');
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpectedChopped, PA, PointEqualsFn), 'P2b');
  // chop from one elem array
  OA := Copy(OA1);
  OSlice := TArrayUtils.Chop<TTestObj>(OA, 0, 0);
  OExpectedSlice := TArray<TTestObj>.Create(O1);
  OExpectedChopped := TArray<TTestObj>.Create();
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpectedSlice, OSlice, TestObjEqualsFn), 'Oa');
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpectedChopped, OA, TestObjEqualsFn), 'Ob');
end;

procedure TestTArrayUtils.TestCompare_ComparerFunc_Overload;
var
  IALocal1, IALocal2, IALocal3: TArray<Integer>;
  PALocal1, PALocal2: TArray<TPoint>;
begin
  CheckEquals(0, TArrayUtils.Compare<Integer>(IA0, IA0Dup, IntCompareFn), 'I1');
  CheckTrue(0 > TArrayUtils.Compare<Integer>(IA3, IA4, IntCompareFn), 'I2');
  CheckTrue(0 > TArrayUtils.Compare<Integer>(IA0, IA4, IntCompareFn), 'I3');
  CheckEquals(0, TArrayUtils.Compare<Integer>(IA2, IA2Dup, IntCompareFn), 'I4');
  CheckTrue(0 < TArrayUtils.Compare<Integer>(IA4, IA3, IntCompareFn), 'I5');
  IALocal1 := TArray<Integer>.Create(1, 2, 3, 4);
  IALocal2 := TArray<Integer>.Create(1, 2, 3);
  IALocal3 := TArray<Integer>.Create(1, 3, 2, 4);
  CheckTrue(0 < TArrayUtils.Compare<Integer>(IALocal1, IALocal2, IntCompareFn), 'I6');
  CheckTrue(0 > TArrayUtils.Compare<Integer>(IALocal2, IALocal1, IntCompareFn), 'I7');
  CheckTrue(0 < TArrayUtils.Compare<Integer>(IALocal3, IALocal2, IntCompareFn), 'I8');
  CheckTrue(0 > TArrayUtils.Compare<Integer>(IALocal1, IALocal3, IntCompareFn), 'I9');

  CheckTrue(0 > TArrayUtils.Compare<string>(SA6, SA5, StrCompareStrFn), 'S1');
  CheckEquals(0, TArrayUtils.Compare<string>(SA2, SA2Dup, StrCompareStrFn), 'S2');
  CheckTrue(0 < TArrayUtils.Compare<string>(SA5, SA4, StrCompareStrFn), 'S3');
  CheckEquals(0, TArrayUtils.Compare<string>(SA2, SA2DupIgnoreCase, StrCompareTextFn), 'S4');
  CheckTrue(0 < TArrayUtils.Compare<string>(SA2, SA2DupIgnoreCase, StrCompareStrFn), 'S5');

  CheckEquals(0, TArrayUtils.Compare<TPoint>(PA0, PA0, PointCompareFn), 'P1');
  CheckTrue(0 > TArrayUtils.Compare<TPoint>(PA0, PA1, PointCompareFn), 'P2');
  CheckEquals(0, TArrayUtils.Compare<TPoint>(PA2, PA2dup, PointCompareFn), 'P3');
  CheckTrue(0 < TArrayUtils.Compare<TPoint>(PA2, PA2short, PointCompareFn), 'P4');
  CheckTrue(0 > TArrayUtils.Compare<TPoint>(PA2short, PA2, PointCompareFn), 'P5');
  PALocal1 := TArray<TPoint>.Create(Pp1p3, Pm1p5);
  PALocal2 := TArray<TPoint>.Create(Pp1p3, Pp12p5);
  CheckTrue(0 > TArrayUtils.Compare<TPoint>(PALocal1, PALocal2, PointCompareFn), 'P6');

  CheckEquals(0, TArrayUtils.Compare<TTestObj>(OA2, OA2Dup, TestObjCompareFn), 'O1');
  CheckTrue(0 < TArrayUtils.Compare<TTestObj>(OA2, OA1, TestObjCompareFn), 'O2');
  CheckTrue(0 > TArrayUtils.Compare<TTestObj>(OA2, OA2Rev, TestObjCompareFn), 'O3');
end;

procedure TestTArrayUtils.TestCompare_ComparerObj_Overload;
var
  IALocal1, IALocal2, IALocal3: TArray<Integer>;
  PALocal1, PALocal2: TArray<TPoint>;
begin
  CheckEquals(0, TArrayUtils.Compare<Integer>(IA0, IA0Dup, IntegerComparer), 'I1');
  CheckTrue(0 > TArrayUtils.Compare<Integer>(IA3, IA4, IntegerComparer), 'I2');
  CheckTrue(0 > TArrayUtils.Compare<Integer>(IA0, IA4, IntegerComparer), 'I3');
  CheckEquals(0, TArrayUtils.Compare<Integer>(IA2, IA2Dup, IntegerComparer), 'I4');
  CheckTrue(0 < TArrayUtils.Compare<Integer>(IA4, IA3, IntegerComparer), 'I5');
  IALocal1 := TArray<Integer>.Create(1, 2, 3, 4);
  IALocal2 := TArray<Integer>.Create(1, 2, 3);
  IALocal3 := TArray<Integer>.Create(1, 3, 2, 4);
  CheckTrue(0 < TArrayUtils.Compare<Integer>(IALocal1, IALocal2, IntegerComparer), 'I6');
  CheckTrue(0 > TArrayUtils.Compare<Integer>(IALocal2, IALocal1, IntegerComparer), 'I7');
  CheckTrue(0 < TArrayUtils.Compare<Integer>(IALocal3, IALocal2, IntegerComparer), 'I8');
  CheckTrue(0 > TArrayUtils.Compare<Integer>(IALocal1, IALocal3, IntegerComparer), 'I9');

  CheckTrue(0 > TArrayUtils.Compare<string>(SA6, SA5, StringComparer), 'S1');
  CheckEquals(0, TArrayUtils.Compare<string>(SA2, SA2Dup, StringComparer), 'S2');
  CheckTrue(0 < TArrayUtils.Compare<string>(SA5, SA4, StringComparer), 'S3');
  CheckEquals(0, TArrayUtils.Compare<string>(SA2, SA2DupIgnoreCase, TextComparer), 'S4');
  CheckTrue(0 < TArrayUtils.Compare<string>(SA2, SA2DupIgnoreCase, StringComparer), 'S5');

  CheckEquals(0, TArrayUtils.Compare<TPoint>(PA0, PA0, PointComparer), 'P1');
  CheckTrue(0 > TArrayUtils.Compare<TPoint>(PA0, PA1, PointComparer), 'P2');
  CheckEquals(0, TArrayUtils.Compare<TPoint>(PA2, PA2dup, PointComparer), 'P3');
  CheckTrue(0 < TArrayUtils.Compare<TPoint>(PA2, PA2short, PointComparer), 'P4');
  CheckTrue(0 > TArrayUtils.Compare<TPoint>(PA2short, PA2, PointComparer), 'P5');
  PALocal1 := TArray<TPoint>.Create(Pp1p3, Pm1p5);
  PALocal2 := TArray<TPoint>.Create(Pp1p3, Pp12p5);
  CheckTrue(0 > TArrayUtils.Compare<TPoint>(PALocal1, PALocal2, PointComparer), 'P6');

  CheckEquals(0, TArrayUtils.Compare<TTestObj>(OA2, OA2Dup, TestObjComparer), 'O1');
  CheckTrue(0 < TArrayUtils.Compare<TTestObj>(OA2, OA1, TestObjComparer), 'O2');
  CheckTrue(0 > TArrayUtils.Compare<TTestObj>(OA2, OA2Rev, TestObjComparer), 'O3');
end;

procedure TestTArrayUtils.TestCompare_NilComparer_Overload;
var
  IALocal1, IALocal2, IALocal3: TArray<Integer>;
begin
  CheckEquals(0, TArrayUtils.Compare<Integer>(IA0, IA0Dup), 'I1');
  CheckTrue(0 > TArrayUtils.Compare<Integer>(IA3, IA4), 'I2');
  CheckTrue(0 > TArrayUtils.Compare<Integer>(IA0, IA4), 'I3');
  CheckEquals(0, TArrayUtils.Compare<Integer>(IA2, IA2Dup), 'I4');
  CheckTrue(0 < TArrayUtils.Compare<Integer>(IA4, IA3), 'I5');
  IALocal1 := TArray<Integer>.Create(1, 2, 3, 4);
  IALocal2 := TArray<Integer>.Create(1, 2, 3);
  IALocal3 := TArray<Integer>.Create(1, 3, 2, 4);
  CheckTrue(0 < TArrayUtils.Compare<Integer>(IALocal1, IALocal2), 'I6');
  CheckTrue(0 > TArrayUtils.Compare<Integer>(IALocal2, IALocal1), 'I7');
  CheckTrue(0 < TArrayUtils.Compare<Integer>(IALocal3, IALocal2), 'I8');
  CheckTrue(0 > TArrayUtils.Compare<Integer>(IALocal1, IALocal3), 'I9');

  CheckTrue(0 > TArrayUtils.Compare<string>(SA6, SA5), 'S1');
  CheckEquals(0, TArrayUtils.Compare<string>(SA2, SA2Dup), 'S2');
  CheckTrue(0 < TArrayUtils.Compare<string>(SA5, SA4), 'S3');
  CheckTrue(0 < TArrayUtils.Compare<string>(SA2, SA2DupIgnoreCase), 'S4');

  // No TPoint or TTestObj overload tests: the default comparer can't be relied upon
end;

procedure TestTArrayUtils.TestConcat;
var
  IGot, IExpected: TArray<Integer>;
  SGot, SExpected: TArray<string>;
  PGot, PExpected: TArray<TPoint>;
  OGot, OExpected: TArray<TTestObj>;
begin
  IGot := TArrayUtils.Concat<Integer>(IA2, IA3);
  IExpected := TArray<Integer>.Create(2, 4, 6, 8, 1, 3, 4, 6, 9);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I1');

  IGot := TArrayUtils.Concat<Integer>(IA2, IA3);
  IExpected := TArray<Integer>.Create(2, 4, 6, 8, 1, 3, 4, 6, 9);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I2');

  IGot := TArrayUtils.Concat<Integer>(IA2, IA1);
  IExpected := TArray<Integer>.Create(2, 4, 6, 8, 7);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I3');

  IGot := TArrayUtils.Concat<Integer>(IA0, IA2);
  IExpected := TArray<Integer>.Create(2, 4, 6, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I4a');

  IGot := TArrayUtils.Concat<Integer>(IA2, IA0);
  IExpected := TArray<Integer>.Create(2, 4, 6, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I4b');

  IGot := TArrayUtils.Concat<Integer>(IA0, IA0);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I5');

  IGot := TArrayUtils.Concat<Integer>(IA2, IA2);
  IExpected := TArray<Integer>.Create(2, 4, 6, 8, 2, 4, 6, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I6');

  SGot := TArrayUtils.Concat<string>(SA1five, SA1two);
  SExpected := TArray<string>.Create('five', 'two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot, StrEqualsStrFn), 'S');

  PGot := TArrayUtils.Concat<TPoint>(PA2short, PA4);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pp1p3Dup, Pm1p5, Pp1p3, Pm8m9, Pm1p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P');

  OGot := TArrayUtils.Concat<TTestObj>(OA0, OA3);
  OExpected := TArray<TTestObj>.Create(O4, O5, O3, O2);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OGot), 'O');
end;

procedure TestTArrayUtils.TestContains_ComparerFunc_Overload;
begin
  CheckTrue(TArrayUtils.Contains<Integer>(4, IA2, IntEqualsFn), 'I1');
  CheckTrue(TArrayUtils.Contains<Integer>(7, IA1, IntEqualsFn), 'I2');
  CheckFalse(TArrayUtils.Contains<Integer>(8, IA3, IntEqualsFn), 'I3');
  CheckFalse(TArrayUtils.Contains<Integer>(0, IA0, IntEqualsFn), 'I4');

  CheckTrue(TArrayUtils.Contains<string>('four', SA2, StrEqualsStrFn), 'S1a');
  CheckFalse(TArrayUtils.Contains<string>('FOUR', SA2, StrEqualsStrFn), 'S1b');
  CheckTrue(TArrayUtils.Contains<string>('SIX', SA2DupIgnoreCase, StrEqualsStrFn), 'S2a');
  CheckFalse(TArrayUtils.Contains<string>('Six', SA2DupIgnoreCase, StrEqualsStrFn), 'S2b');
  CheckFalse(TArrayUtils.Contains<string>('four', SA6, StrEqualsStrFn), 'S3');
  CheckTrue(TArrayUtils.Contains<string>('one', SA6, StrEqualsStrFn), 'S4');
  CheckFalse(TArrayUtils.Contains<string>('one', SA0, StrEqualsStrFn), 'S5');

  CheckTrue(TArrayUtils.Contains<string>('four', SA2, StrEqualsTextFn), 'T1a');
  CheckTrue(TArrayUtils.Contains<string>('FOUR', SA2, StrEqualsTextFn), 'T1b');
  CheckTrue(TArrayUtils.Contains<string>('SIX', SA2DupIgnoreCase, StrEqualsTextFn), 'T2a');
  CheckTrue(TArrayUtils.Contains<string>('Six', SA2DupIgnoreCase, StrEqualsTextFn), 'T2b');
  CheckFalse(TArrayUtils.Contains<string>('four', SA6, StrEqualsTextFn), 'T3');
  CheckTrue(TArrayUtils.Contains<string>('one', SA6, StrEqualsTextFn), 'T4');
  CheckFalse(TArrayUtils.Contains<string>('four', SA0, StrEqualsTextFn), 'T5');

  CheckTrue(TArrayUtils.Contains<TPoint>(Pp1p3, PA1, PointEqualsFn), 'P1');
  CheckTrue(TArrayUtils.Contains<TPoint>(Pp1p3, PA2, PointEqualsFn), 'P2');
  CheckTrue(TArrayUtils.Contains<TPoint>(Pm8m9, PA3, PointEqualsFn), 'P3');
  CheckFalse(TArrayUtils.Contains<TPoint>(Pp12m12, PA4, PointEqualsFn), 'P4');
  CheckFalse(TArrayUtils.Contains<TPoint>(Pp12m12, PA0, PointEqualsFn), 'P5');

  CheckTrue(TArrayUtils.Contains<TTestObj>(O3, OATwoPeeks, TestObjEqualsFn), 'O1');
  CheckTrue(TArrayUtils.Contains<TTestObj>(O2Dup, OA2, TestObjEqualsFn), 'O2');
  CheckFalse(TArrayUtils.Contains<TTestObj>(O1, OA3, TestObjEqualsFn), 'O3');
end;

procedure TestTArrayUtils.TestContains_ComparerObj_Overload;
begin
  CheckTrue(TArrayUtils.Contains<Integer>(4, IA2, IntegerEqualityComparer), 'I1');
  CheckTrue(TArrayUtils.Contains<Integer>(7, IA1, IntegerEqualityComparer), 'I2');
  CheckFalse(TArrayUtils.Contains<Integer>(8, IA3, IntegerEqualityComparer), 'I3');
  CheckFalse(TArrayUtils.Contains<Integer>(0, IA0, IntegerEqualityComparer), 'I4');

  CheckTrue(TArrayUtils.Contains<string>('four', SA2, StringEqualityComparer), 'S1a');
  CheckFalse(TArrayUtils.Contains<string>('FOUR', SA2, StringEqualityComparer), 'S1b');
  CheckTrue(TArrayUtils.Contains<string>('SIX', SA2DupIgnoreCase, StringEqualityComparer), 'S2a');
  CheckFalse(TArrayUtils.Contains<string>('Six', SA2DupIgnoreCase, StringEqualityComparer), 'S2b');
  CheckFalse(TArrayUtils.Contains<string>('four', SA6, StringEqualityComparer), 'S3');
  CheckTrue(TArrayUtils.Contains<string>('one', SA6, StringEqualityComparer), 'S4');
  CheckFalse(TArrayUtils.Contains<string>('one', SA0, StringEqualityComparer), 'S5');

  CheckTrue(TArrayUtils.Contains<string>('four', SA2, TextEqualityComparer), 'T1a');
  CheckTrue(TArrayUtils.Contains<string>('FOUR', SA2, TextEqualityComparer), 'T1b');
  CheckTrue(TArrayUtils.Contains<string>('SIX', SA2DupIgnoreCase, TextEqualityComparer), 'T2a');
  CheckTrue(TArrayUtils.Contains<string>('Six', SA2DupIgnoreCase, TextEqualityComparer), 'T2b');
  CheckFalse(TArrayUtils.Contains<string>('four', SA6, TextEqualityComparer), 'T3');
  CheckTrue(TArrayUtils.Contains<string>('one', SA6, TextEqualityComparer), 'T4');
  CheckFalse(TArrayUtils.Contains<string>('four', SA0, TextEqualityComparer), 'T5');

  CheckTrue(TArrayUtils.Contains<TPoint>(Pp1p3, PA1, PointEqualityComparer), 'P1');
  CheckTrue(TArrayUtils.Contains<TPoint>(Pp1p3, PA2, PointEqualityComparer), 'P2');
  CheckTrue(TArrayUtils.Contains<TPoint>(Pm8m9, PA3, PointEqualityComparer), 'P3');
  CheckFalse(TArrayUtils.Contains<TPoint>(Pp12m12, PA4, PointEqualityComparer), 'P4');
  CheckFalse(TArrayUtils.Contains<TPoint>(Pp12m12, PA0, PointEqualityComparer), 'P5');

  CheckTrue(TArrayUtils.Contains<TTestObj>(O3, OATwoPeeks, TestObjEqualityComparer), 'O1');
  CheckTrue(TArrayUtils.Contains<TTestObj>(O2Dup, OA2, TestObjEqualityComparer), 'O2');
  CheckFalse(TArrayUtils.Contains<TTestObj>(O1, OA3, TestObjEqualityComparer), 'O3');
end;

procedure TestTArrayUtils.TestContains_NilComparer_Overload;
begin
  CheckTrue(TArrayUtils.Contains<Integer>(4, IA2), 'I1');
  CheckTrue(TArrayUtils.Contains<Integer>(7, IA1), 'I2');
  CheckFalse(TArrayUtils.Contains<Integer>(8, IA3), 'I3');
  CheckFalse(TArrayUtils.Contains<Integer>(0, IA0), 'I4');

  CheckTrue(TArrayUtils.Contains<string>('four', SA2), 'S1a');
  CheckFalse(TArrayUtils.Contains<string>('FOUR', SA2), 'S1b');
  CheckTrue(TArrayUtils.Contains<string>('SIX', SA2DupIgnoreCase), 'S2a');
  CheckFalse(TArrayUtils.Contains<string>('Six', SA2DupIgnoreCase), 'S2b');
  CheckFalse(TArrayUtils.Contains<string>('four', SA6), 'S3');
  CheckTrue(TArrayUtils.Contains<string>('one', SA6), 'S4');
  CheckFalse(TArrayUtils.Contains<string>('one', SA0), 'S5');

  CheckTrue(TArrayUtils.Contains<TPoint>(Pp1p3, PA1), 'P1');
  CheckTrue(TArrayUtils.Contains<TPoint>(Pp1p3, PA2), 'P2');
  CheckTrue(TArrayUtils.Contains<TPoint>(Pm8m9, PA3), 'P3');
  CheckFalse(TArrayUtils.Contains<TPoint>(Pp12m12, PA4), 'P4');
  CheckFalse(TArrayUtils.Contains<TPoint>(Pp12m12, PA0), 'P5');

  CheckTrue(TArrayUtils.Contains<TTestObj>(O3, OATwoPeeks), 'O1');
  CheckFalse(TArrayUtils.Contains<TTestObj>(O2, OA2Dup), 'O2');
  CheckFalse(TArrayUtils.Contains<TTestObj>(O1, OA3), 'O3');
end;

procedure TestTArrayUtils.TestCopyReversed;
var
  IR: TArray<Integer>;
  SR: TArray<string>;
  ObjR: TArray<TTestObj>;
begin
  IR := TArrayUtils.CopyReversed<Integer>(IA2);
  CheckTrue(TArrayUtils.Equal<Integer>(IA2Rev, IR, IntEqualsFn), 'I1');
  IR := TArrayUtils.CopyReversed<Integer>(IA0);
  CheckTrue(TArrayUtils.Equal<Integer>(IA0, IR, IntEqualsFn), 'I2');
  IR := TArrayUtils.CopyReversed<Integer>(IA3);
  CheckTrue(TArrayUtils.Equal<Integer>(IA3Rev, IR, IntEqualsFn), 'I3');
  IR := TArrayUtils.CopyReversed<Integer>(IA6);
  CheckTrue(TArrayUtils.Equal<Integer>(IA6, IR, IntEqualsFn), 'I4');

  SR := TArrayUtils.CopyReversed<string>(SA2);
  CheckTrue(TArrayUtils.Equal<string>(SA2Rev, SR, StrEqualsStrFn), 'S1');
  SR := TArrayUtils.CopyReversed<string>(SA0);
  CheckTrue(TArrayUtils.Equal<string>(SA0, SR, StrEqualsStrFn), 'S2');
  SR := TArrayUtils.CopyReversed<string>(SA1five);
  CheckTrue(TArrayUtils.Equal<string>(SA1five, SR, StrEqualsStrFn), 'S3');

  SR := TArrayUtils.CopyReversed<string>(SA2DupIgnoreCase);
  CheckTrue(TArrayUtils.Equal<string>(SA2Rev, SR, StrEqualsTextFn), 'T');

  ObjR := TArrayUtils.CopyReversed<TTestObj>(OA2);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OA2Rev, ObjR, TestObjEqualsFn), 'O');
end;

procedure TestTArrayUtils.TestCopySorted_ComparerFunc_Overload;
var
  IGot, IExpected: TArray<Integer>;
  RevIntCompareFn: TComparison<Integer>;
  SGot, SExpected, SA: TArray<string>;
  PGot, PExpected: TArray<TPoint>;
  OGot, OExpected: TArray<TTestObj>;
begin
  RevIntCompareFn := function(const Left, Right: Integer): Integer
    begin
      Result := -IntCompareFn(Left, Right);
    end;

  IGot := TArrayUtils.CopySorted<Integer>(IA2Rev, IntCompareFn);
  IExpected := Copy(IA2);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I1');

  IGot := TArrayUtils.CopySorted<Integer>(IA5, IntCompareFn);
  IExpected := TArray<Integer>.Create(0, 0, 1, 1, 2, 2, 3, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I2');

  IGot := TArrayUtils.CopySorted<Integer>(IA6, RevIntCompareFn);
  IExpected := TArray<Integer>.Create(9, 9, 9, 9, 9, 9, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I3');

  IGot := TArrayUtils.CopySorted<Integer>(IA0, IntCompareFn);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I4');

  SA := TArray<string>.Create('b', 'C', 'A', 'd');
  SGot := TArrayUtils.CopySorted<string>(SA, StrCompareStrFn);
  SExpected := TArray<string>.Create('A', 'C', 'b', 'd');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S1a');

  SA := TArray<string>.Create('b', 'C', 'A', 'd');
  SGot := TArrayUtils.CopySorted<string>(SA, StrCompareTextFn);
  SExpected := TArray<string>.Create('A', 'b', 'C', 'd');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S1b');

  SGot := TArrayUtils.CopySorted<string>(SA7, StrCompareStrFn);
  SExpected := TArray<string>.Create('five', 'one', 'one', 'three', 'three', 'two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S2');

  PGot := TArrayUtils.CopySorted<TPoint>(PA3, PointCompareFn);
  PExpected := TArray<TPoint>.Create(Pm8m9, Pm8m9, Pm1p5, Pm1p5, Pp1p3, Pp1p3);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P');

  OGot := TArrayUtils.CopySorted<TTestObj>(OA3, TestObjCompareFn);
  OExpected := TArray<TTestObj>.Create(O4, O2, O3, O5);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OGot, TestObjEqualsFn), 'O');
end;

procedure TestTArrayUtils.TestCopySorted_ComparerObj_Overload;
var
  IGot, IExpected: TArray<Integer>;
  SGot, SExpected, SA: TArray<string>;
  PGot, PExpected: TArray<TPoint>;
  OGot, OExpected: TArray<TTestObj>;
begin
  IGot := TArrayUtils.CopySorted<Integer>(IA2Rev, IntegerComparer);
  IExpected := Copy(IA2);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I1');

  IGot := TArrayUtils.CopySorted<Integer>(IA5, IntegerComparer);
  IExpected := TArray<Integer>.Create(0, 0, 1, 1, 2, 2, 3, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I2');

  IGot := TArrayUtils.CopySorted<Integer>(IA0, IntegerComparer);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I3');

  SA := TArray<string>.Create('b', 'C', 'A', 'd');
  SGot := TArrayUtils.CopySorted<string>(SA, StringComparer);
  SExpected := TArray<string>.Create('A', 'C', 'b', 'd');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S1a');

  SA := TArray<string>.Create('b', 'C', 'A', 'd');
  SGot := TArrayUtils.CopySorted<string>(SA, TextComparer);
  SExpected := TArray<string>.Create('A', 'b', 'C', 'd');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S1b');

  SGot := TArrayUtils.CopySorted<string>(SA7, StringComparer);
  SExpected := TArray<string>.Create('five', 'one', 'one', 'three', 'three', 'two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S2');

  PGot := TArrayUtils.CopySorted<TPoint>(PA3, PointComparer);
  PExpected := TArray<TPoint>.Create(Pm8m9, Pm8m9, Pm1p5, Pm1p5, Pp1p3, Pp1p3);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P');

  OGot := TArrayUtils.CopySorted<TTestObj>(OA3, TestObjComparer);
  OExpected := TArray<TTestObj>.Create(O4, O2, O3, O5);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OGot, TestObjEqualsFn), 'O');
end;

procedure TestTArrayUtils.TestCopySorted_NilComparer_Overload;
var
  IA, IExpected: TArray<Integer>;
  SA, SExpected: TArray<string>;
begin
  IA := Copy(IA2Rev);
  TArrayUtils.Sort<Integer>(IA);
  IExpected := TArray<Integer>.Create();
  IExpected := Copy(IA2);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1');

  IA := Copy(IA5);
  TArrayUtils.Sort<Integer>(IA);
  IExpected := TArray<Integer>.Create(0, 0, 1, 1, 2, 2, 3, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2');

  IA := Copy(IA0);
  TArrayUtils.Sort<Integer>(IA);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3');

  SA := TArray<string>.Create('b', 'C', 'A', 'd');
  TArrayUtils.Sort<string>(SA);
  SExpected := TArray<string>.Create('A', 'C', 'b', 'd');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S1');

  SA := Copy(SA7);
  TArrayUtils.Sort<string>(SA);
  SExpected := TArray<string>.Create('five', 'one', 'one', 'three', 'three', 'two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S2');
end;

procedure TestTArrayUtils.TestCopy_Deep_Overload;
var
  PGot: TArray<TPoint>;
  OElem: TTestObj;
  OCopy: TArray<TTestObj>;
  PCloner: TArrayUtils.TCloner<TPoint>;
  Idx: Integer;
begin
  try
    OCopy := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
    CheckEquals(Length(OA2), Length(OCopy), 'O: Deep array sizes');
    for Idx := 0 to Pred(Length(OA2)) do
    begin
      CheckTrue(OA2[Idx].Equals(OCopy[Idx]), Format('O: Deep element %d equality check', [Idx]));
      CheckFalse(OA2[Idx] = OCopy[Idx], Format('O: Deep element %d pointer check', [Idx]));
    end;
  finally
    for OElem in OCopy do
      OElem.Free;
  end;

  PCloner := function (const P: TPoint): TPoint
    begin
      Result := P;
    end;
  PGot := TArrayUtils.Copy<TPoint>(PA4, PCloner);
  CheckTrue(TArrayUtils.Equal<TPoint>(PGot, PA4), 'P1');
  PGot := TArrayUtils.Copy<TPoint>(PA1, PCloner);
  CheckTrue(TArrayUtils.Equal<TPoint>(PGot, PA1), 'P2');
  PGot := TArrayUtils.Copy<TPoint>(PA0, PCloner);
  CheckTrue(TArrayUtils.Equal<TPoint>(PGot, PA0), 'P3');

end;

procedure TestTArrayUtils.TestCopy_Shallow_Overload;
var
  IGot: TArray<Integer>;
  SGot: TArray<string>;
  PGot: TArray<TPoint>;
  OCopy: TArray<TTestObj>;
  Idx: Integer;
begin
  IGot := TArrayUtils.Copy<Integer>(IA5);
  CheckTrue(TArrayUtils.Equal<Integer>(IGot, IA5), 'I1');
  IGot := TArrayUtils.Copy<Integer>(IA1);
  CheckTrue(TArrayUtils.Equal<Integer>(IGot, IA1), 'I2');
  IGot := TArrayUtils.Copy<Integer>(IA0);
  CheckTrue(TArrayUtils.Equal<Integer>(IGot, IA0), 'I3');

  SGot := TArrayUtils.Copy<string>(SA7);
  CheckTrue(TArrayUtils.Equal<string>(SGot, SA7), 'S1');
  SGot := TArrayUtils.Copy<string>(SA1five);
  CheckTrue(TArrayUtils.Equal<string>(SGot, SA1five), 'S2');
  SGot := TArrayUtils.Copy<string>(SA0);
  CheckTrue(TArrayUtils.Equal<string>(SGot, SA0), 'S3');

  PGot := TArrayUtils.Copy<TPoint>(PA4);
  CheckTrue(TArrayUtils.Equal<TPoint>(PGot, PA4), 'P1');
  PGot := TArrayUtils.Copy<TPoint>(PA1);
  CheckTrue(TArrayUtils.Equal<TPoint>(PGot, PA1), 'P2');
  PGot := TArrayUtils.Copy<TPoint>(PA0);
  CheckTrue(TArrayUtils.Equal<TPoint>(PGot, PA0), 'P3');

  OCopy := TArrayUtils.Copy<TTestObj>(OA2);
  CheckEquals(Length(OA2), Length(OCopy), 'O1: Array sizes');
  for Idx := 0 to Pred(Length(OA2)) do
  begin
    CheckTrue(OA2[Idx].Equals(OCopy[Idx]), Format('O1: Element %d equality check', [Idx]));
    CheckTrue(OA2[Idx] = OCopy[Idx], Format('O1: Element %d pointer check', [Idx]));
  end;

  OCopy := TArrayUtils.Copy<TTestObj>(OA0);
  CheckEquals(Length(OA0), Length(OCopy), 'O2 Array sizes');

end;

procedure TestTArrayUtils.TestDeDup_ComparerFunc_Overload;
var
  IExpected, IGot: TArray<Integer>;
  SExpected, SGot, SALocal: TArray<string>;
  PExpected, PGot: TArray<TPoint>;
begin
  IGot := TArrayUtils.DeDup<Integer>(IA5, IntEqualsFn);
  IExpected := TArray<Integer>.Create(0, 1, 2, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I1');

  IGot := TArrayUtils.DeDup<Integer>(IA6, IntEqualsFn);
  IExpected := TArray<Integer>.Create(9, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I2');

  IGot := TArrayUtils.DeDup<Integer>(IA3, IntEqualsFn);
  IExpected := IA3;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I3');

  IGot := TArrayUtils.DeDup<Integer>(IA1, IntEqualsFn);
  IExpected := IA1;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I4');

  IGot := TArrayUtils.DeDup<Integer>(IA0, IntEqualsFn);
  IExpected := IA0;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I5');

  SGot := TArrayUtils.DeDup<string>(SA5, StrEqualsStrFn);
  SExpected := TArray<string>.Create('one', 'two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S1');

  SGot := TArrayUtils.DeDup<string>(SA2, StrEqualsStrFn);
  SExpected := SA2;
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S2');

  SALocal := TArray<string>.Create('one', 'ONE', 'two', 'Two', 'two');

  SGot := TArrayUtils.DeDup<string>(SALocal, StrEqualsStrFn);
  SExpected := TArray<string>.Create('one', 'ONE', 'two', 'Two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S3a');

  SGot := TArrayUtils.DeDup<string>(SALocal, StrEqualsTextFn);
  SExpected := TArray<string>.Create('one', 'two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S3b');

  PGot := TArrayUtils.DeDup<TPoint>(PA2, PointEqualsFn);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pm1p5, Pp12m12, Pm8m9, Pp12p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P1');

  PGot := TArrayUtils.DeDup<TPoint>(PA3, PointEqualsFn);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pm1p5, Pm8m9);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P2');

  PGot := TArrayUtils.DeDup<TPoint>(PA4, PointEqualsFn);
  PExpected := PA4;
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P3');
end;

procedure TestTArrayUtils.TestDeDup_ComparerObj_Overload;
var
  IExpected, IGot: TArray<Integer>;
  SExpected, SGot, SALocal: TArray<string>;
  PExpected, PGot: TArray<TPoint>;
begin
  IGot := TArrayUtils.DeDup<Integer>(IA5, IntegerEqualityComparer);
  IExpected := TArray<Integer>.Create(0, 1, 2, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I1');

  IGot := TArrayUtils.DeDup<Integer>(IA6, IntegerEqualityComparer);
  IExpected := TArray<Integer>.Create(9, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I2');

  IGot := TArrayUtils.DeDup<Integer>(IA3, IntegerEqualityComparer);
  IExpected := IA3;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I3');

  IGot := TArrayUtils.DeDup<Integer>(IA1, IntegerEqualityComparer);
  IExpected := IA1;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I4');

  IGot := TArrayUtils.DeDup<Integer>(IA0, IntegerEqualityComparer);
  IExpected := IA0;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I5');

  SGot := TArrayUtils.DeDup<string>(SA5, StringEqualityComparer);
  SExpected := TArray<string>.Create('one', 'two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S1');

  SGot := TArrayUtils.DeDup<string>(SA2, StringEqualityComparer);
  SExpected := SA2;
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S2');

  SALocal := TArray<string>.Create('one', 'ONE', 'two', 'Two', 'two');

  SGot := TArrayUtils.DeDup<string>(SALocal, StringEqualityComparer);
  SExpected := TArray<string>.Create('one', 'ONE', 'two', 'Two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S3a');

  SGot := TArrayUtils.DeDup<string>(SALocal, TextEqualityComparer);
  SExpected := TArray<string>.Create('one', 'two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S3b');

  PGot := TArrayUtils.DeDup<TPoint>(PA2, PointEqualityComparer);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pm1p5, Pp12m12, Pm8m9, Pp12p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P1');

  PGot := TArrayUtils.DeDup<TPoint>(PA3, PointEqualityComparer);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pm1p5, Pm8m9);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P2');

  PGot := TArrayUtils.DeDup<TPoint>(PA4, PointEqualityComparer);
  PExpected := PA4;
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P3');
end;

procedure TestTArrayUtils.TestDeDup_NilComparer_Overload;
var
  IExpected, IGot: TArray<Integer>;
  SExpected, SGot, SALocal: TArray<string>;
  PExpected, PGot: TArray<TPoint>;
begin
  IGot := TArrayUtils.DeDup<Integer>(IA5);
  IExpected := TArray<Integer>.Create(0, 1, 2, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I1');

  IGot := TArrayUtils.DeDup<Integer>(IA6);
  IExpected := TArray<Integer>.Create(9, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I2');

  IGot := TArrayUtils.DeDup<Integer>(IA3);
  IExpected := IA3;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I3');

  IGot := TArrayUtils.DeDup<Integer>(IA1);
  IExpected := IA1;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I4');

  IGot := TArrayUtils.DeDup<Integer>(IA0);
  IExpected := IA0;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I5');

  SGot := TArrayUtils.DeDup<string>(SA5);
  SExpected := TArray<string>.Create('one', 'two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S1');

  SGot := TArrayUtils.DeDup<string>(SA2);
  SExpected := SA2;
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S2');

  SALocal := TArray<string>.Create('one', 'ONE', 'two', 'Two', 'two');

  SGot := TArrayUtils.DeDup<string>(SALocal);
  SExpected := TArray<string>.Create('one', 'ONE', 'two', 'Two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S3');

  PGot := TArrayUtils.DeDup<TPoint>(PA2);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pm1p5, Pp12m12, Pm8m9, Pp12p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P1');

  PGot := TArrayUtils.DeDup<TPoint>(PA3);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pm1p5, Pm8m9);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P2');

  PGot := TArrayUtils.DeDup<TPoint>(PA4);
  PExpected := PA4;
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P3');
end;

procedure TestTArrayUtils.TestDeleteAndFreeRange_DoubleIdx_Overload;
var
  StartInstanceCount: Integer;
  OA, OExpected: TArray<TTestObj>;
begin
  StartInstanceCount := TTestObj.InstanceCount;

  // 3 elements from middle of array: 3 objects should be deleted & freed
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O1:instances-begin');
    TArrayUtils.DeleteAndFreeRange<TTestObj>(OA, 1, 3);
    OExpected := TArray<TTestObj>.Create(O1, O5);
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O1:after-delete');
    CheckEquals(2, Length(OA), 'O1:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O1:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O1:instances-end');

  // low index -ve, end idx 1: 2 objects should be deleted & freed
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O2:instances-begin');
    TArrayUtils.DeleteAndFreeRange<TTestObj>(OA, -1, 1);
    OExpected := TArray<TTestObj>.Create(O3, O4, O5);
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O2:after-delete-content');
    CheckEquals(3, Length(OA), 'O2:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O2:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O2:instances-end');

  // low idx = 2, end beyond end of array: 3 objects should be deleted & freed
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O3:instances-begin');
    TArrayUtils.DeleteAndFreeRange<TTestObj>(OA, 2, Length(OA2));
    OExpected := TArray<TTestObj>.Create(O1, O2);
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O3:after-delete');
    CheckEquals(2, Length(OA), 'O3:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O3:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O3:instances-end');

  // end idx < start idx: 0 objects should be deleted & freed
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O4:instances-begin');
    TArrayUtils.DeleteAndFreeRange<TTestObj>(OA, 3, 2);
    OExpected := TArray<TTestObj>.Create(O1, O2, O3, O4, O5);
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O4:after-delete');
    CheckEquals(5, Length(OA), 'O4:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O4:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O4:instances-end');
end;

procedure TestTArrayUtils.TestDeleteAndFreeRange_SingleIdx_Overload;
var
  StartInstanceCount: Integer;
  OA, OExpected: TArray<TTestObj>;
begin
  StartInstanceCount := TTestObj.InstanceCount;

  // from idx 2 to end: 3 objects should be deleted and freed
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O1:instances-begin');
    TArrayUtils.DeleteAndFreeRange<TTestObj>(OA, 2);
    OExpected := TArray<TTestObj>.Create(O1, O2);
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O1:after-delete');
    CheckEquals(2, Length(OA), 'O1:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O1:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O1:instances-end');

  // from -ve idx to end: all 5 objects should be deleted & freed
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O2:instances-begin');
    TArrayUtils.DeleteAndFreeRange<TTestObj>(OA, -1);
    OExpected := TArray<TTestObj>.Create();
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O2:after-delete-content');
    CheckEquals(0, Length(OA), 'O2:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O2:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O2:instances-end');

  // from idx 0 to end: all 5 objects should be deleted & freed
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O3:instances-begin');
    TArrayUtils.DeleteAndFreeRange<TTestObj>(OA, 0);
    OExpected := TArray<TTestObj>.Create();
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O3:after-delete');
    CheckEquals(0, Length(OA), 'O3:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O3:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O3:instances-end');

  // from beyond length of array: 0 objects should be deleted & freed
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O4:instances-begin');
    TArrayUtils.DeleteAndFreeRange<TTestObj>(OA, Length(OA2));
    OExpected := TArray<TTestObj>.Create(O1, O2, O3, O4, O5);
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O4:after-delete');
    CheckEquals(5, Length(OA), 'O4:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O4:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O4:instances-end');
end;

procedure TestTArrayUtils.TestDeleteAndFree_MultipleIndices_Overload;
var
  StartInstanceCount: Integer;
  OA, OExpected: TArray<TTestObj>;
begin
  StartInstanceCount := TTestObj.InstanceCount;

  // 3 indices all in range, 1 duplicated: 3 objects should be deleted & freed
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O1:instances-begin');
    TArrayUtils.DeleteAndFree<TTestObj>(OA, [1, 3, 0, 3]);
    OExpected := TArray<TTestObj>.Create(O3, O5);
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O1:after-delete');
    CheckEquals(2, Length(OA), 'O1:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O1:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O1:instances-end');

  // indexes all out of range: no objects should be deleted or freed
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O2:instances-begin');
    TArrayUtils.DeleteAndFree<TTestObj>(OA, [-1, 9, -6]);
    OExpected := TArray<TTestObj>.Create(O1, O2, O3, O4, O5);
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O2:after-delete-content');
    CheckEquals(5, Length(OA), 'O2:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O2:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O2:instances-end');

  // all array deleted: 5 objects should be deleted & freed
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O3:instances-begin');
    TArrayUtils.DeleteAndFree<TTestObj>(OA, [0, 2, 4, 3, 1]);
    OExpected := TArray<TTestObj>.Create();
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O3:after-delete');
    CheckEquals(0, Length(OA), 'O3:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O3:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O3:instances-end');
end;

procedure TestTArrayUtils.TestDeleteAndFree_SingleIndex_Overload;
var
  StartInstanceCount: Integer;
  OA, OExpected: TArray<TTestObj>;
begin
  StartInstanceCount := TTestObj.InstanceCount;

  // index in range: 1 object should be deleted & freed
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O1:instances-begin');
    TArrayUtils.DeleteAndFree<TTestObj>(OA, 2);
    OExpected := TArray<TTestObj>.Create(O1, O2, O4, O5);
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O1:after-delete');
    CheckEquals(4, Length(OA), 'O1:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O1:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O1:instances-end');

  // index out of range: no objects should be deleted or freed
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O2:instances-begin');
    TArrayUtils.DeleteAndFree<TTestObj>(OA, -1);
    OExpected := TArray<TTestObj>.Create(O1, O2, O3, O4, O5);
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O2:after-delete-content');
    CheckEquals(5, Length(OA), 'O2:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O2:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O2:instances-end');
end;

procedure TestTArrayUtils.TestDeleteAndReleaseRange_DoubleIdx_Overload;
var
  R0, R1, R2, R3, R4, R5, R6, R7, R: TTestResource;
  RA, RExpected: TArray<TTestResource>;
  Freer: TArrayUtils.TCallback<TTestResource>;
begin
  Freer := procedure (const ARes: TTestResource)
    begin
      ARes.Release;
    end;

  // test normal range
  R0 := TTestResource.Create('A', 1); R1 := TTestResource.Create('B', 2);
  R2 := TTestResource.Create('C', 3); R3 := TTestResource.Create('D', 4);
  R4 := TTestResource.Create('D', 5); R5 := TTestResource.Create('F', 6);
  R6 := TTestResource.Create('G', 7); R7 := TTestResource.Create('H', 8);
  RA := TArray<TTestResource>.Create(R0, R1, R2, R3, R4, R5, R6, R7);
  CheckEquals(8, TTestResource.InstanceCount, 'R1: check 8 instances');
  TArrayUtils.DeleteAndReleaseRange<TTestResource>(RA, 1, 4, Freer);
  RExpected := TArray<TTestResource>.Create(R0, R5, R6, R7);
  CheckTrue(TArrayUtils.Equal<TTestResource>(RExpected, RA), 'R1: check array post deletion');
  CheckEquals(4, TTestResource.InstanceCount, 'R1: check 4 instances after deletion');
  ReleaseTestResources(RA);
  CheckEquals(0, TTestResource.InstanceCount, 'R1: all instance released');

  // test range starting with -ve index to mid array
  R0 := TTestResource.Create('A', 1); R1 := TTestResource.Create('B', 2);
  R2 := TTestResource.Create('C', 3); R3 := TTestResource.Create('D', 4);
  R4 := TTestResource.Create('D', 5); R5 := TTestResource.Create('F', 6);
  R6 := TTestResource.Create('G', 7); R7 := TTestResource.Create('H', 8);
  RA := TArray<TTestResource>.Create(R0, R1, R2, R3, R4, R5, R6, R7);
  CheckEquals(8, TTestResource.InstanceCount, 'R2: check 8 instances');
  TArrayUtils.DeleteAndReleaseRange<TTestResource>(RA, -1, 4, Freer);
  RExpected := TArray<TTestResource>.Create(R5, R6, R7);
  CheckTrue(TArrayUtils.Equal<TTestResource>(RExpected, RA), 'R2: check array post deletion');
  CheckEquals(3, TTestResource.InstanceCount, 'R2: check 3 instances after deletion');
  ReleaseTestResources(RA);
  CheckEquals(0, TTestResource.InstanceCount, 'R2: all instance released');

  // test range from mid array to beyond end
  R0 := TTestResource.Create('A', 1); R1 := TTestResource.Create('B', 2);
  R2 := TTestResource.Create('C', 3); R3 := TTestResource.Create('D', 4);
  R4 := TTestResource.Create('D', 5); R5 := TTestResource.Create('F', 6);
  R6 := TTestResource.Create('G', 7); R7 := TTestResource.Create('H', 8);
  RA := TArray<TTestResource>.Create(R0, R1, R2, R3, R4, R5, R6, R7);
  CheckEquals(8, TTestResource.InstanceCount, 'R3: check 8 instances');
  TArrayUtils.DeleteAndReleaseRange<TTestResource>(RA, 4, 99, Freer);
  RExpected := TArray<TTestResource>.Create(R0, R1, R2, R3);
  CheckTrue(TArrayUtils.Equal<TTestResource>(RExpected, RA), 'R3: check array post deletion');
  CheckEquals(4, TTestResource.InstanceCount, 'R3: check 4 instances after deletion');
  for R in RA do
    R.Release;
  CheckEquals(0, TTestResource.InstanceCount, 'R3: all instance released');

  // test range from start to end of array
  R0 := TTestResource.Create('A', 1); R1 := TTestResource.Create('B', 2);
  R2 := TTestResource.Create('C', 3); R3 := TTestResource.Create('D', 4);
  R4 := TTestResource.Create('D', 5); R5 := TTestResource.Create('F', 6);
  R6 := TTestResource.Create('G', 7); R7 := TTestResource.Create('H', 8);
  RA := TArray<TTestResource>.Create(R0, R1, R2, R3, R4, R5, R6, R7);
  CheckEquals(8, TTestResource.InstanceCount, 'R4: check 8 instances');
  TArrayUtils.DeleteAndReleaseRange<TTestResource>(RA, 0, Pred(Length(RA)), Freer);
  RExpected := TArray<TTestResource>.Create();
  CheckTrue(TArrayUtils.Equal<TTestResource>(RExpected, RA), 'R4: check array post deletion');
  CheckEquals(0, TTestResource.InstanceCount, 'R4: check 0 instances after deletion');
  ReleaseTestResources(RA);
  CheckEquals(0, TTestResource.InstanceCount, 'R4: all instance released');
end;

procedure TestTArrayUtils.TestDeleteAndReleaseRange_SingleIdx_Overload;
var
  R0, R1, R2, R3, R4, R5, R6, R7: TTestResource;
  RA, RExpected: TArray<TTestResource>;
  Freer: TArrayUtils.TCallback<TTestResource>;
begin
  Freer := procedure (const ARes: TTestResource)
    begin
      ARes.Release;
    end;

  // Test delete from middle index to end
  R0 := TTestResource.Create('A', 1); R1 := TTestResource.Create('B', 2);
  R2 := TTestResource.Create('C', 3); R3 := TTestResource.Create('D', 4);
  R4 := TTestResource.Create('D', 5); R5 := TTestResource.Create('F', 6);
  R6 := TTestResource.Create('G', 7); R7 := TTestResource.Create('H', 8);
  RA := TArray<TTestResource>.Create(R0, R1, R2, R3, R4, R5, R6, R7);
  CheckEquals(8, TTestResource.InstanceCount, 'R1: check 8 instances');
  TArrayUtils.DeleteAndReleaseRange<TTestResource>(RA, 3, Freer);
  RExpected := TArray<TTestResource>.Create(R0, R1, R2);
  CheckTrue(TArrayUtils.Equal<TTestResource>(RExpected, RA), 'R1: check array post deletion');
  CheckEquals(3, TTestResource.InstanceCount, 'R1: check 3 instances after deletion');
  ReleaseTestResources(RA);
  CheckEquals(0, TTestResource.InstanceCount, 'R1: all instance released');

  // Test delete from 1st index to end
  R0 := TTestResource.Create('A', 1); R1 := TTestResource.Create('B', 2);
  R2 := TTestResource.Create('C', 3); R3 := TTestResource.Create('D', 4);
  R4 := TTestResource.Create('D', 5); R5 := TTestResource.Create('F', 6);
  R6 := TTestResource.Create('G', 7); R7 := TTestResource.Create('H', 8);
  RA := TArray<TTestResource>.Create(R0, R1, R2, R3, R4, R5, R6, R7);
  CheckEquals(8, TTestResource.InstanceCount, 'R2: check 8 instances');
  TArrayUtils.DeleteAndReleaseRange<TTestResource>(RA, 0, Freer);
  RExpected := TArray<TTestResource>.Create();
  CheckTrue(TArrayUtils.Equal<TTestResource>(RExpected, RA), 'R2: check array post deletion');
  CheckEquals(0, TTestResource.InstanceCount, 'R2: check 0 instances after deletion');
  ReleaseTestResources(RA);
  CheckEquals(0, TTestResource.InstanceCount, 'R2: all instance released');
end;

procedure TestTArrayUtils.TestDeleteAndRelease_MultipleIndices_Overload;
var
  R0, R1, R2, R3, R4, R5: TTestResource;
  RA, RExpected: TArray<TTestResource>;
  Freer: TArrayUtils.TCallback<TTestResource>;
begin
  Freer := procedure (const ARes: TTestResource)
    begin
      ARes.Release;
    end;
  R0 := TTestResource.Create('A', 1); R1 := TTestResource.Create('B', 2);
  R2 := TTestResource.Create('C', 3); R3 := TTestResource.Create('D', 4);
  R4 := TTestResource.Create('D', 5); R5 := TTestResource.Create('F', 6);
  RA := TArray<TTestResource>.Create(R0, R1, R2, R3, R4, R5);
  CheckEquals(6, TTestResource.InstanceCount, 'R1: check 6 instances');

  TArrayUtils.DeleteAndRelease<TTestResource>(RA, [1,3,5], Freer);
  RExpected := TArray<TTestResource>.Create(R0, R2, R4);
  CheckTrue(TArrayUtils.Equal<TTestResource>(RExpected, RA), 'R1: check array post deletion');
  CheckEquals(3, TTestResource.InstanceCount, 'R1: check 3 instances after deletion');

  ReleaseTestResources(RA);
  CheckEquals(0, TTestResource.InstanceCount, 'R1: all instance released');
end;

procedure TestTArrayUtils.TestDeleteAndRelease_SingleIndex_Overload;
var
  R1, R2, R3, R4: TTestResource;
  RA, RExpected: TArray<TTestResource>;
  Freer: TArrayUtils.TCallback<TTestResource>;
begin
  Freer := procedure (const ARes: TTestResource)
    begin
      ARes.Release;
    end;
  R1 := TTestResource.Create('A', 1); R2 := TTestResource.Create('B', 2);
  R3 := TTestResource.Create('C', 3); R4 := TTestResource.Create('D', 4);
  RA := TArray<TTestResource>.Create(R1, R2, R3, R4);
  CheckEquals(4, TTestResource.InstanceCount, 'R: check 4 instances');

  TArrayUtils.DeleteAndRelease<TTestResource>(RA, 2, Freer);
  RExpected := TArray<TTestResource>.Create(R1, R2, R4);
  CheckTrue(TArrayUtils.Equal<TTestResource>(RExpected, RA), 'R: check array post deletion');
  CheckEquals(3, TTestResource.InstanceCount, 'R: check 3 instances after deletion');

  ReleaseTestResources(RA);
  CheckEquals(0, TTestResource.InstanceCount, 'R: all instance released');
end;

procedure TestTArrayUtils.TestDeleteRange_DoubleIdx_Overload;
var
  IA, IExpected: TArray<Integer>;
  SA, SExpected: TArray<string>;
  PA, PExpected: TArray<TPoint>;
  OA, OExpected: TArray<TTestObj>;
begin
  IA := Copy(IA5);
  TArrayUtils.DeleteRange<Integer>(IA, 2, 4);
  IExpected := TArray<Integer>.Create(0, 1, 3, 2, 1, 0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1');

  IA := Copy(IA5);
  TArrayUtils.DeleteRange<Integer>(IA, 1, 8);
  IExpected := TArray<Integer>.Create(0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2');

  IA := Copy(IA5);
  TArrayUtils.DeleteRange<Integer>(IA, 0, 2);
  IExpected := TArray<Integer>.Create(3, 4, 3, 2, 1, 0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3');

  IA := Copy(IA5);
  TArrayUtils.DeleteRange<Integer>(IA, 7, 99);
  IExpected := TArray<Integer>.Create(0, 1, 2, 3, 4, 3, 2);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I4');

  IA := Copy(IA5);
  TArrayUtils.DeleteRange<Integer>(IA, 2, 2);
  IExpected := TArray<Integer>.Create(0, 1, 3, 4, 3, 2, 1, 0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I5');

  IA := Copy(IA5);
  TArrayUtils.DeleteRange<Integer>(IA, -2, 2);
  IExpected := TArray<Integer>.Create(3, 4, 3, 2, 1, 0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I6');

  IA := Copy(IA5);
  TArrayUtils.DeleteRange<Integer>(IA, -2, 27);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I7');

  IA := Copy(IA5);
  TArrayUtils.DeleteRange<Integer>(IA, 7, 99);
  IExpected := TArray<Integer>.Create(0, 1, 2, 3, 4, 3, 2);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I8');

  IA := Copy(IA0);
  TArrayUtils.DeleteRange<Integer>(IA, 0, 0);
  IExpected := IA0;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I9');

  IA := Copy(IA5);
  TArrayUtils.DeleteRange<Integer>(IA, 20, 99);
  IExpected := IA5;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I10');

  IA := Copy(IA5);
  TArrayUtils.DeleteRange<Integer>(IA, 3, 2);
  IExpected := IA5;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I11');

  SA := Copy(SA3);
  TArrayUtils.DeleteRange<string>(SA, 1, 3);
  SExpected := TArray<string>.Create('one', 'nine');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA, StrEqualsStrFn), 'S');

  PA := Copy(PA3);
  TArrayUtils.DeleteRange<TPoint>(PA, 2, 3);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pm1p5, Pm1p5, Pp1p3);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA, PointEqualsFn), 'P');

  OA := Copy(OA2);
  TArrayUtils.DeleteRange<TTestObj>(OA, 2, 2);
  OExpected := TArray<TTestObj>.Create(O1, O2, O4, O5);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O');
end;

procedure TestTArrayUtils.TestDeleteRange_SingleIdx_Overload;
var
  IA, IExpected: TArray<Integer>;
  SA, SExpected: TArray<string>;
  PA, PExpected: TArray<TPoint>;
  OA, OExpected: TArray<TTestObj>;
begin
  IA := Copy(IA3);
  TArrayUtils.DeleteRange<Integer>(IA, 2);
  IExpected := TArray<Integer>.Create(1, 3);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1');

  IA := Copy(IA3);
  TArrayUtils.DeleteRange<Integer>(IA, 0);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2');

  SA := TArrayUtils.Copy<string>(SA1five);
  TArrayUtils.DeleteRange<string>(SA, 0);
  SExpected := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S1');

  SA := TArrayUtils.Copy<string>(SA3);
  TArrayUtils.DeleteRange<string>(SA, 4);
  SExpected := TArray<string>.Create('one', 'three', 'four', 'six');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S2');

  SA := TArrayUtils.Copy<string>(SA3);
  TArrayUtils.DeleteRange<string>(SA, 0);
  SExpected := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S3');

  SA := TArrayUtils.Copy<string>(SA3);
  TArrayUtils.DeleteRange<string>(SA, 1);
  SExpected := TArray<string>.Create('one');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S4');

  PA := Copy(PA2);
  TArrayUtils.DeleteRange<TPoint>(PA, 4);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pp1p3Dup, Pm1p5, Pp12m12);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA), 'P');

  OA := Copy(OA2);
  TArrayUtils.DeleteRange<TTestObj>(OA, 2);
  OExpected := TArray<TTestObj>.Create(O1, O2);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA), 'O');
end;

procedure TestTArrayUtils.TestDelete_MultipleIndices_Overload;
var
  IA, IExpected: TArray<Integer>;
  SA, SExpected: TArray<string>;
  PA, PExpected: TArray<TPoint>;
  OA, OExpected: TArray<TTestObj>;
begin
  IA := Copy(IA7);
  TArrayUtils.Delete<Integer>(IA, [-1, 0, 2, 8, 8, 12]);
  IExpected := TArray<Integer>.Create(5, 4, 3, 5, 8, 3);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1');

  IA := Copy(IA2);
  TArrayUtils.Delete<Integer>(IA, [2]);
  IExpected := TArray<Integer>.Create(2, 4, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2a');

  IA := Copy(IA2);
  TArrayUtils.Delete<Integer>(IA, [2, 2, 2, 2, 2]);
  IExpected := TArray<Integer>.Create(2, 4, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2b');

  IA := Copy(IA2);
  TArrayUtils.Delete<Integer>(IA, [0, 1, 2, 3]);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3');

  IA := Copy(IA0);
  TArrayUtils.Delete<Integer>(IA, [0, 1, 2, 3]);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I4');

  IA := Copy(IA5);
  TArrayUtils.Delete<Integer>(IA, [7, 3, 1, 0]);
  IExpected := TArray<Integer>.Create(2, 4, 3, 2, 0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I5');

  IA := Copy(IA1);
  TArrayUtils.Delete<Integer>(IA, [7, 3, 1, 0, -3]);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I6a');

  IA := Copy(IA1);
  TArrayUtils.Delete<Integer>(IA, [7, 3, 1, -3]);
  IExpected := TArray<Integer>.Create(7);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I6b');

  // nothing delete: both indices out of bounds of the array
  IA := Copy(IA2);
  TArrayUtils.Delete<Integer>(IA, [-1, 12]);
  IExpected := IA2;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I7');

  SA := Copy(SA2);
  TArrayUtils.Delete<string>(SA, [0, 3]);
  SExpected := TArray<string>.Create('four', 'six');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S');

  PA := Copy(PA3);
  TArrayUtils.Delete<TPoint>(PA, [-1, 0, 5, 12]);
  PExpected := TArray<TPoint>.Create(Pm1p5, Pm8m9, Pm8m9, Pm1p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA), 'P');

  OA := Copy(OA3);
  TArrayUtils.Delete<TTestObj>(OA, [2, 2, 2]);
  OExpected := TArray<TTestObj>.Create(O4, O5, O2);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA), 'O');
end;

procedure TestTArrayUtils.TestDelete_SingleIndex_Overload;
var
  IA, IExpected: TArray<Integer>;
  SA, SExpected: TArray<string>;
  PA, PExpected: TArray<TPoint>;
  OA, OExpected: TArray<TTestObj>;
begin
  IA := Copy(IA3);

  TArrayUtils.Delete<Integer>(IA, 2);
  IExpected := TArray<Integer>.Create(1, 3, 6, 9);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1');

  TArrayUtils.Delete<Integer>(IA, 0);
  IExpected := TArray<Integer>.Create(3, 6, 9);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2');

  TArrayUtils.Delete<Integer>(IA, 2);
  IExpected := TArray<Integer>.Create(3, 6);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3');

  TArrayUtils.Delete<Integer>(IA, 1);
  TArrayUtils.Delete<Integer>(IA, 0);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I4');

  SA := Copy(SA1five);
  TArrayUtils.Delete<string>(SA, 0);
  SExpected := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S1');

  SA := Copy(SA3);

  TArrayUtils.Delete<string>(SA, 4);
  SExpected := TArray<string>.Create('one', 'three', 'four', 'six');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S2');

  TArrayUtils.Delete<string>(SA, 0);
  SExpected := TArray<string>.Create('three', 'four', 'six');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S3');

  TArrayUtils.Delete<string>(SA, 1);
  SExpected := TArray<string>.Create('three', 'six');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S4');

  PA := Copy(PA2);
  TArrayUtils.Delete<TPoint>(PA, 4);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pp1p3Dup, Pm1p5, Pp12m12, Pp12p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA), 'P');

  OA := Copy(OA2);
  TArrayUtils.Delete<TTestObj>(OA, 2);
  OExpected := TArray<TTestObj>.Create(O1, O2, O4, O5);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA), 'O');
end;

procedure TestTArrayUtils.TestEqualStart_ComparerFunc_Overload;
begin
  CheckFalse(TArrayUtils.EqualStart<Integer>(IA0, IA0Dup, 1, IntEqualsFn), 'I1');
  CheckFalse(TArrayUtils.EqualStart<Integer>(IA3, IA4, 3, IntEqualsFn), 'I2a');
  CheckTrue(TArrayUtils.EqualStart<Integer>(IA3, IA4, 2, IntEqualsFn), 'I2b');
  CheckTrue(TArrayUtils.EqualStart<Integer>(IA3, IA4, 1, IntEqualsFn), 'I2c');
  CheckFalse(TArrayUtils.EqualStart<Integer>(IA2, IA2Dup, 5, IntEqualsFn), 'I3a');
  CheckTrue(TArrayUtils.EqualStart<Integer>(IA2, IA2Dup, 4, IntEqualsFn), 'I3b');

  CheckTrue(TArrayUtils.EqualStart<string>(SA2, SA2Dup, 2, StrEqualsStrFn), 'S1a');
  CheckFalse(TArrayUtils.EqualStart<string>(SA2, SA2Dup, 9, StrEqualsStrFn), 'S1b');
  CheckFalse(TArrayUtils.EqualStart<string>(SA2, SA2DupIgnoreCase, 2, StrEqualsStrFn), 'S2a');
  CheckTrue(TArrayUtils.EqualStart<string>(SA2, SA2DupIgnoreCase, 2, StrEqualsTextFn), 'S2b');
  CheckTrue(TArrayUtils.EqualStart<string>(SA2, SA2DupIgnoreCase, 4, StrEqualsTextFn), 'S2c');
  CheckFalse(TArrayUtils.EqualStart<string>(SA2, SA3, 2, StrEqualsStrFn), 'S3a');
  CheckFalse(TArrayUtils.EqualStart<string>(SA3, SA4, 3, StrEqualsStrFn), 'S3b');
  CheckTrue(TArrayUtils.EqualStart<string>(SA1two, SA2, 1, StrEqualsTextFn), 'S4');

  CheckTrue(TArrayUtils.EqualStart<TPoint>(PA2, PA2dup, 6, PointEqualsFn), 'P1');
  CheckFalse(TArrayUtils.EqualStart<TPoint>(PA2, PA2dup, 7, PointEqualsFn), 'P2a');
  CheckTrue(TArrayUtils.EqualStart<TPoint>(PA2, PA2short, 2, PointEqualsFn), 'P2b');
  CheckTrue(TArrayUtils.EqualStart<TPoint>(PA1, PA1, 1, PointEqualsFn), 'P3a');
  CheckFalse(TArrayUtils.EqualStart<TPoint>(PA1, PA1, 10, PointEqualsFn), 'P3b');

  CheckTrue(TArrayUtils.EqualStart<TTestObj>(OA2, OATwoPeeks, 3, TestObjEqualsFn), 'O1');
  CheckFalse(TArrayUtils.EqualStart<TTestObj>(OA2, OATwoPeeks, 4, TestObjEqualsFn), 'O2');
  CheckFalse(TArrayUtils.EqualStart<TTestObj>(OA2, OA3, 1, TestObjEqualsFn), 'O3');
  CheckTrue(TArrayUtils.EqualStart<TTestObj>(OA2, OA2Dup, 2, TestObjEqualsFn), 'O4');

  CheckException(EqualStart_ComparerFunc_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestEqualStart_ComparerObj_Overload;
begin
  CheckFalse(TArrayUtils.EqualStart<Integer>(IA0, IA0Dup, 1, IntegerEqualityComparer), 'I1');
  CheckFalse(TArrayUtils.EqualStart<Integer>(IA3, IA4, 3, IntegerEqualityComparer), 'I2a');
  CheckTrue(TArrayUtils.EqualStart<Integer>(IA3, IA4, 2, IntegerEqualityComparer), 'I2b');
  CheckTrue(TArrayUtils.EqualStart<Integer>(IA3, IA4, 1, IntegerEqualityComparer), 'I2c');
  CheckFalse(TArrayUtils.EqualStart<Integer>(IA2, IA2Dup, 5, IntegerEqualityComparer), 'I3a');
  CheckTrue(TArrayUtils.EqualStart<Integer>(IA2, IA2Dup, 4, IntegerEqualityComparer), 'I3b');

  CheckTrue(TArrayUtils.EqualStart<string>(SA2, SA2Dup, 2, StringEqualityComparer), 'S1a');
  CheckFalse(TArrayUtils.EqualStart<string>(SA2, SA2Dup, 9, StringEqualityComparer), 'S1b');
  CheckFalse(TArrayUtils.EqualStart<string>(SA2, SA2DupIgnoreCase, 2, StringEqualityComparer), 'S2a');
  CheckTrue(TArrayUtils.EqualStart<string>(SA2, SA2DupIgnoreCase, 2, TextEqualityComparer), 'S2b');
  CheckTrue(TArrayUtils.EqualStart<string>(SA2, SA2DupIgnoreCase, 4, TextEqualityComparer), 'S2c');
  CheckFalse(TArrayUtils.EqualStart<string>(SA2, SA3, 2, StringEqualityComparer), 'S3a');
  CheckFalse(TArrayUtils.EqualStart<string>(SA3, SA4, 3, StringEqualityComparer), 'S3b');
  CheckTrue(TArrayUtils.EqualStart<string>(SA1two, SA2, 1, TextEqualityComparer), 'S4');

  CheckTrue(TArrayUtils.EqualStart<TPoint>(PA2, PA2dup, 6, PointEqualityComparer), 'P1');
  CheckFalse(TArrayUtils.EqualStart<TPoint>(PA2, PA2dup, 7, PointEqualityComparer), 'P2a');
  CheckTrue(TArrayUtils.EqualStart<TPoint>(PA2, PA2short, 2, PointEqualityComparer), 'P2b');
  CheckTrue(TArrayUtils.EqualStart<TPoint>(PA1, PA1, 1, PointEqualityComparer), 'P3a');
  CheckFalse(TArrayUtils.EqualStart<TPoint>(PA1, PA1, 10, PointEqualityComparer), 'P3b');

  CheckTrue(TArrayUtils.EqualStart<TTestObj>(OA2, OATwoPeeks, 3, TestObjEqualityComparer), 'O1');
  CheckFalse(TArrayUtils.EqualStart<TTestObj>(OA2, OATwoPeeks, 4, TestObjEqualityComparer), 'O2');
  CheckFalse(TArrayUtils.EqualStart<TTestObj>(OA2, OA3, 1, TestObjEqualityComparer), 'O3');
  CheckTrue(TArrayUtils.EqualStart<TTestObj>(OA2, OA2Dup, 2, TestObjEqualityComparer), 'O4');

  CheckException(EqualStart_ComparerObj_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestEqualStart_NilComparer_Overload;
begin
  CheckFalse(TArrayUtils.EqualStart<Integer>(IA0, IA0Dup, 1), 'I1');
  CheckFalse(TArrayUtils.EqualStart<Integer>(IA3, IA4, 3), 'I2a');
  CheckTrue(TArrayUtils.EqualStart<Integer>(IA3, IA4, 2), 'I2b');
  CheckTrue(TArrayUtils.EqualStart<Integer>(IA3, IA4, 1), 'I2c');
  CheckFalse(TArrayUtils.EqualStart<Integer>(IA2, IA2Dup, 5), 'I3a');
  CheckTrue(TArrayUtils.EqualStart<Integer>(IA2, IA2Dup, 4), 'I3b');

  CheckTrue(TArrayUtils.EqualStart<string>(SA2, SA2Dup, 2), 'S1a');
  CheckFalse(TArrayUtils.EqualStart<string>(SA2, SA2Dup, 9), 'S1b');
  CheckFalse(TArrayUtils.EqualStart<string>(SA2, SA2DupIgnoreCase, 2), 'S2');
  CheckFalse(TArrayUtils.EqualStart<string>(SA2, SA3, 2), 'S3a');
  CheckFalse(TArrayUtils.EqualStart<string>(SA3, SA4, 3), 'S3b');
  CheckTrue(TArrayUtils.EqualStart<string>(SA1two, SA2, 1), 'S4');

  CheckTrue(TArrayUtils.EqualStart<TPoint>(PA2, PA2dup, 6), 'P1');
  CheckFalse(TArrayUtils.EqualStart<TPoint>(PA2, PA2dup, 7), 'P2a');
  CheckTrue(TArrayUtils.EqualStart<TPoint>(PA2, PA2short, 2), 'P2b');
  CheckTrue(TArrayUtils.EqualStart<TPoint>(PA1, PA1, 1), 'P3a');
  CheckFalse(TArrayUtils.EqualStart<TPoint>(PA1, PA1, 10), 'P3b');

  CheckTrue(TArrayUtils.EqualStart<TTestObj>(OA2, OATwoPeeks, 3), 'O1');
  CheckFalse(TArrayUtils.EqualStart<TTestObj>(OA2, OATwoPeeks, 4), 'O2');
  CheckFalse(TArrayUtils.EqualStart<TTestObj>(OA2, OA3, 1), 'O3');
  CheckFalse(TArrayUtils.EqualStart<TTestObj>(OA2, OA2Dup, 2), 'O4');

  CheckException(EqualStart_NilComparer_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestEqual_ComparerFunc_Overload;
begin
  CheckTrue(TArrayUtils.Equal<Integer>(IA2, IA2Dup, IntEqualsFn), 'I1');
  CheckFalse(TArrayUtils.Equal<Integer>(IA2, IA1, IntEqualsFn), 'I2');
  CheckFalse(TArrayUtils.Equal<Integer>(IA2, IA3, IntEqualsFn), 'I3');
  CheckTrue(TArrayUtils.Equal<Integer>(IA0, IA0Dup, IntEqualsFn), 'I4');
  CheckFalse(TArrayUtils.Equal<Integer>(IA4, IA1, IntEqualsFn), 'I5');

  CheckTrue(TArrayUtils.Equal<string>([], SA0, StrEqualsStrFn), 'S1');
  CheckFalse(TArrayUtils.Equal<string>(SA2, SA3, StrEqualsStrFn), 'S2');
  CheckTrue(TArrayUtils.Equal<string>(SA1five, SA1five, StrEqualsStrFn), 'S3');
  CheckTrue(TArrayUtils.Equal<string>(SA2, SA2Dup, StrEqualsStrFn), 'S4');
  CheckFalse(TArrayUtils.Equal<string>(SA2, SA2DupIgnoreCase, StrEqualsStrFn), 'S5');

  CheckTrue(TArrayUtils.Equal<string>([], SA0, StrEqualsTextFn), 'T1');
  CheckFalse(TArrayUtils.Equal<string>(SA2, SA3, StrEqualsTextFn), 'T2');
  CheckTrue(TArrayUtils.Equal<string>(SA1five, SA1five, StrEqualsTextFn), 'T3');
  CheckTrue(TArrayUtils.Equal<string>(SA2, SA2Dup, StrEqualsTextFn), 'T4');
  CheckTrue(TArrayUtils.Equal<string>(SA2, SA2DupIgnoreCase, StrEqualsTextFn), 'T5');

  CheckTrue(TArrayUtils.Equal<TPoint>(PA2, PA2dup, PointEqualsFn), 'P1');
  CheckTrue(TArrayUtils.Equal<TPoint>([], PA0, PointEqualsFn), 'P2');

  CheckTrue(TArrayUtils.Equal<TTestObj>(OA2, OA2Dup, TestObjEqualsFn), 'O1');
  CheckFalse(TArrayUtils.Equal<TTestObj>(OA2, OA3, TestObjEqualsFn), 'O2');
  CheckTrue(TArrayUtils.Equal<TTestObj>(OA0, OA0, TestObjEqualsFn), 'O3');
  CheckFalse(TArrayUtils.Equal<TTestObj>(OA2, OA2Rev, TestObjEqualsFn), 'O4');
end;

procedure TestTArrayUtils.TestEqual_ComparerObj_Overload;
begin
  CheckTrue(TArrayUtils.Equal<Integer>(IA2, IA2Dup, IntegerEqualityComparer), 'I1');
  CheckFalse(TArrayUtils.Equal<Integer>(IA2, IA1, IntegerEqualityComparer), 'I2');
  CheckFalse(TArrayUtils.Equal<Integer>(IA2, IA3, IntegerEqualityComparer), 'I3');
  CheckTrue(TArrayUtils.Equal<Integer>(IA0, IA0Dup, IntegerEqualityComparer), 'I4');
  CheckFalse(TArrayUtils.Equal<Integer>(IA4, IA1, IntegerEqualityComparer), 'I5');

  CheckTrue(TArrayUtils.Equal<string>(SA0, SA0, StringEqualityComparer), 'S1');
  CheckFalse(TArrayUtils.Equal<string>(SA2, SA3, StringEqualityComparer), 'S2');
  CheckTrue(TArrayUtils.Equal<string>(SA1five, SA1five, StringEqualityComparer), 'S3');
  CheckTrue(TArrayUtils.Equal<string>(SA2, SA2Dup, StringEqualityComparer), 'S4');
  CheckFalse(TArrayUtils.Equal<string>(SA2, SA2DupIgnoreCase, StringEqualityComparer), 'S5');

  CheckTrue(TArrayUtils.Equal<string>(SA0, SA0, TextEqualityComparer), 'T1');
  CheckFalse(TArrayUtils.Equal<string>(SA2, SA3, TextEqualityComparer), 'T2');
  CheckTrue(TArrayUtils.Equal<string>(SA1five, SA1five, TextEqualityComparer), 'T3');
  CheckTrue(TArrayUtils.Equal<string>(SA2, SA2Dup, TextEqualityComparer), 'T4');
  CheckTrue(TArrayUtils.Equal<string>(SA2, SA2DupIgnoreCase, TextEqualityComparer), 'T5');

  CheckTrue(TArrayUtils.Equal<TPoint>(PA2, PA2dup, PointEqualityComparer), 'P1');
  CheckTrue(TArrayUtils.Equal<TPoint>([], PA0, PointEqualityComparer), 'P2');

  CheckTrue(TArrayUtils.Equal<TTestObj>(OA2, OA2Dup, TestObjEqualityComparer), 'O1');
  CheckFalse(TArrayUtils.Equal<TTestObj>(OA2, OA3, TestObjEqualityComparer), 'O2');
  CheckTrue(TArrayUtils.Equal<TTestObj>(OA0, OA0, TestObjEqualityComparer), 'O3');
  CheckFalse(TArrayUtils.Equal<TTestObj>(OA2, OA2Rev, TestObjEqualityComparer), 'O4');
end;

procedure TestTArrayUtils.TestEqual_NilComparer_Overload;
begin
  CheckTrue(TArrayUtils.Equal<Integer>(IA2, IA2Dup), 'I1');
  CheckFalse(TArrayUtils.Equal<Integer>(IA2, IA1), 'I2');
  CheckFalse(TArrayUtils.Equal<Integer>(IA2, IA3), 'I3');
  CheckTrue(TArrayUtils.Equal<Integer>(IA0, IA0Dup), 'I4');
  CheckFalse(TArrayUtils.Equal<Integer>(IA4, IA1), 'I5');

  CheckTrue(TArrayUtils.Equal<string>(SA0, SA0), 'S1');
  CheckFalse(TArrayUtils.Equal<string>(SA2, SA3), 'S2');
  CheckTrue(TArrayUtils.Equal<string>(SA1five, SA1five), 'S3');
  CheckTrue(TArrayUtils.Equal<string>(SA2, SA2Dup), 'S4');
  CheckFalse(TArrayUtils.Equal<string>(SA2, SA2DupIgnoreCase), 'S5');

  CheckTrue(TArrayUtils.Equal<TPoint>(PA2, PA2dup), 'P1');
  CheckTrue(TArrayUtils.Equal<TPoint>([], PA0), 'P2');

  CheckFalse(TArrayUtils.Equal<TTestObj>(OA2, OA2Dup), 'O1');
  CheckFalse(TArrayUtils.Equal<TTestObj>(OA2, OA3), 'O2');
  CheckTrue(TArrayUtils.Equal<TTestObj>(OA0, OA0), 'O3');
  CheckFalse(TArrayUtils.Equal<TTestObj>(OA2, OA2Rev), 'O4');
end;

procedure TestTArrayUtils.TestEvery_ExtendedCallback_Overload;
var
  ICallback: TArrayUtils.TConstraintEx<Integer>;
  SCallback: TArrayUtils.TConstraintEx<string>;
  PCallback: TArrayUtils.TConstraintEx<TPoint>;
begin
  ICallback := function (const AElem: Integer; const AIndex: Integer;
    const A: array of Integer): Boolean
    var
      Distance: Integer;
    begin
      // True iff distance betwent element and prior element <=1
      // Assume that single element arrays meet the criteria
      // Assume that single element arrays meet the criteria
      Assert(A[AIndex] = AElem);
      if AIndex = 0 then
        Exit(True);
      Distance := Abs(A[AIndex] - A[AIndex - 1]);
      Result := Distance <= 1;
    end;
  CheckTrue(TArrayUtils.Every<Integer>(IA5, ICallback), 'Ia');
  CheckTrue(TArrayUtils.Every<Integer>(IA6, ICallback), 'Ib');
  CheckFalse(TArrayUtils.Every<Integer>(IA2, ICallback), 'Ic');
  CheckTrue(TArrayUtils.Every<Integer>(IA1, ICallback), 'Id');

  SCallback := function (const AElem: string; const AIndex: Integer;
    const A: array of string): Boolean
    var
      Count: Integer;
      Elem: string;
    begin
      // Checks if array contains duplicate of AElem
      Count := 0;
      for Elem in A do
        if Elem = AElem then
          Inc(Count);
      Result := Count >= 2;
    end;
  CheckTrue(TArrayUtils.Every<string>(SA5, SCallback), 'Sa');
  CheckFalse(TArrayUtils.Every<string>(SA1two, SCallback), 'Sb');
  CheckFalse(TArrayUtils.Every<string>(SA6, SCallback), 'Sc');

  PCallback := function (const AElem: TPoint; const AIndex: Integer;
    const A: array of TPoint): Boolean
    var
      Count: Integer;
      Elem: TPoint;
    begin
      // Checks if array contains duplicate of AElem
      Count := 0;
      for Elem in A do
        if PointEqualsFn(Elem, AElem) then
          Inc(Count);
      Result := Count >= 2;
    end;
  CheckTrue(TArrayUtils.Every<TPoint>(PA3, PCallback), 'Pa');
  CheckFalse(TArrayUtils.Every<TPoint>(PA2, PCallback), 'Pb');
  CheckFalse(TArrayUtils.Every<TPoint>(PA4, PCallback), 'Pc');

  CheckException(Every_ExtendedCallback_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestEvery_SimpleCallback_Overload;
var
  ICallback: TArrayUtils.TConstraint<Integer>;
  SCallback: TArrayUtils.TConstraint<string>;
  PCallback: TArrayUtils.TConstraint<TPoint>;
  OCallback: TArrayUtils.TConstraint<TTestObj>;
begin
  ICallback := function(const I: Integer): Boolean begin Result := I > 5; end;
  CheckTrue(TArrayUtils.Every<Integer>(IA6, ICallback), 'I1a');
  CheckTrue(TArrayUtils.Every<Integer>(IA1, ICallback), 'I1b');
  CheckFalse(TArrayUtils.Every<Integer>(IA5, ICallback), 'I1c');

  ICallback := function(const I: Integer): Boolean begin Result := Odd(I); end;
  CheckTrue(TArrayUtils.Every<Integer>(IA4, ICallback), 'I2a');
  CheckTrue(TArrayUtils.Every<Integer>(IA1, ICallback), 'I2b');
  CheckFalse(TArrayUtils.Every<Integer>(IA3, ICallback), 'I2c');
  CheckFalse(TArrayUtils.Every<Integer>(IA6, ICallback), 'I2d');

  SCallback := function(const S: string): Boolean begin Result := S = LowerCase(S); end;
  CheckTrue(TArrayUtils.Every<string>(SA2, SCallback), 'S1a');
  CheckFalse(TArrayUtils.Every<string>(SA2DupIgnoreCase, SCallback), 'S1b');
  CheckTrue(TArrayUtils.Every<string>(SA1five, SCallback), 'S1c');

  PCallback := function(const P: TPoint): Boolean begin Result := DistFromOrigin(P) < 6.0; end;
  CheckTrue(TArrayUtils.Every<TPoint>(PA2short, PCallback), 'P1a');
  CheckFalse(TArrayUtils.Every<TPoint>(PA2, PCallback), 'P1b');

  OCallback := function(const P: TTestObj): Boolean begin Result := (P.A = 'd') or (P.B.IndexOf('d') >= 0); end;
  CheckTrue(TArrayUtils.Every<TTestObj>(OATwoPeeks, OCallback), 'O1a');
  CheckFalse(TArrayUtils.Every<TTestObj>(OA3, OCallback), 'O1b');

  CheckException(Every_SimpleCallback_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestFindAllIndices_ExtendedCallback_Overload;

  function ElementsAfter(const Str: string; const A: array of string): TArray<Integer>;
  var
    StrIdx: Integer;
  begin
    StrIdx := TArrayUtils.IndexOf<string>(Str, A);
    Result := TArrayUtils.FindAllIndices<string>(
      A,
      function (const AElem: string; const AIndex: Integer;
        const A: array of string): Boolean
      begin
        Result := AIndex > StrIdx;
      end
    );
  end;

var
  Got, Expected: TArray<Integer>;
  SameOddnessAsFirst: TArrayUtils.TConstraintEx<Integer>;
  DistanceGTFirst: TArrayUtils.TConstraintEx<TPoint>;
begin
  SameOddnessAsFirst := function (const AElem: Integer; const AIndex: Integer;
    const A: array of Integer): Boolean
    var
      FirstOddness: Boolean;
    begin
      Assert(Length(A) > 0);
      FirstOddness := Odd(A[0]);
      Result := Odd(AElem) = FirstOddness;
    end;

  Got := TArrayUtils.FindAllIndices<Integer>(IA5, SameOddnessAsFirst);
  Expected := TArray<Integer>.Create(0, 2, 4, 6, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I1');

  Got := TArrayUtils.FindAllIndices<Integer>(IA6, SameOddnessAsFirst);
  Expected := TArray<Integer>.Create(0, 1, 2, 4, 5, 6);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I2');

  Got := TArrayUtils.FindAllIndices<Integer>(IA1, SameOddnessAsFirst);
  Expected := TArray<Integer>.Create(0);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I3');

  Got := ElementsAfter('six', SA2Rev);
  Expected := TArray<Integer>.Create(2, 3);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S1');

  Got := ElementsAfter('six', SA2);
  Expected := TArray<Integer>.Create(3);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S2');

  Got := ElementsAfter('eight', SA2);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S3');

  DistanceGTFirst := function (const AElem: TPoint; const AIndex: Integer;
    const A: array of TPoint): Boolean
    var
      FirstDistance: Extended;
    begin
      Assert(Length(A) > 0);
      FirstDistance := DistFromOrigin(A[0]);
      Result := DistFromOrigin(AElem) > FirstDistance;
    end;

  Got := TArrayUtils.FindAllIndices<TPoint>(PA2, DistanceGTFirst);
  Expected := TArray<Integer>.Create(2, 3, 4, 5);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P1');

  Got := TArrayUtils.FindAllIndices<TPoint>(PA1, DistanceGTFirst);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P2');
end;

procedure TestTArrayUtils.TestFindAllIndices_SimpleCallback_Overload;
var
  CheckOdd: TArrayUtils.TConstraint<Integer>;
  CheckLongStrs: TArrayUtils.TConstraint<string>;
  CheckDistantPoints: TArrayUtils.TConstraint<TPoint>;
  Expected, Got: TArray<Integer>;
begin
  CheckOdd := function (const I: Integer): Boolean begin Result := Odd(I); end;

  Got := TArrayUtils.FindAllIndices<Integer>(IA3, CheckOdd);
  Expected := TArray<Integer>.Create(0, 1, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got, IntEqualsFn), 'I1');

  Got := TArrayUtils.FindAllIndices<Integer>(IA6, CheckOdd);
  Expected := TArray<Integer>.Create(0, 1, 2, 4, 5, 6);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got, IntEqualsFn), 'I2');

  Got := TArrayUtils.FindAllIndices<Integer>(IA2, CheckOdd);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got, IntEqualsFn), 'I3');

  Got := TArrayUtils.FindAllIndices<Integer>(IA0, CheckOdd);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got, IntEqualsFn), 'I4');

  CheckLongStrs := function(const S: string): Boolean
    begin
      // "Long" strings have > 3 chars!!
      Result := Length(S) > 3;
    end;

  Got := TArrayUtils.FindAllIndices<string>(SA2, CheckLongStrs);
  Expected := TArray<Integer>.Create(1, 3);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S1');

  Got := TArrayUtils.FindAllIndices<string>(SA6, CheckLongStrs);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S2');

  Got := TArrayUtils.FindAllIndices<string>(SA3, CheckLongStrs);
  Expected := TArray<Integer>.Create(1, 2, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S3');

  Got := TArrayUtils.FindAllIndices<string>(SA0, CheckLongStrs);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S4');

  CheckDistantPoints := function(const P: TPoint): Boolean
    begin
      // A point is distant (from origin) if its distance >= 5.0
      Result := DistFromOrigin(P) > 5.0;
    end;

  Got := TArrayUtils.FindAllIndices<TPoint>(PA2, CheckDistantPoints);
  Expected := TArray<Integer>.Create(2, 3, 4, 5);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P1');

  Got := TArrayUtils.FindAllIndices<TPoint>(PA2Short, CheckDistantPoints);
  Expected := TArray<Integer>.Create(2);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P2');

  Got := TArrayUtils.FindAllIndices<TPoint>(PA3, CheckDistantPoints);
  Expected := TArray<Integer>.Create(1, 2, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P3');

  Got := TArrayUtils.FindAllIndices<TPoint>(PA1, CheckDistantPoints);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P4');

  Got := TArrayUtils.FindAllIndices<TPoint>(PA0, CheckDistantPoints);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P5');

  Got := TArrayUtils.FindAllIndices<TTestObj>(
    OA2,
    function (const AElem: TTestObj): Boolean
    begin
      Result := AElem.B.IndexOf('d') >= 0;
    end
  );
  Expected := TArray<Integer>.Create(0, 1, 2);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'O');
end;

procedure TestTArrayUtils.TestFindAll_ExtendedCallback_Overload;
var
  IGot, IExpected: TArray<Integer>;
  SGot, SExpected: TArray<string>;
  PGot, PExpected: TArray<TPoint>;
  SameOddnessAsFirst: TArrayUtils.TConstraintEx<Integer>;
  DistanceGTFirst: TArrayUtils.TConstraintEx<TPoint>;

  function ElementsAfter(const Str: string; const A: array of string): TArray<string>;
  var
    StrIdx: Integer;
  begin
    StrIdx := TArrayUtils.IndexOf<string>(Str, A);
    Result := TArrayUtils.FindAll<string>(
      A,
      function (const AElem: string; const AIndex: Integer;
        const A: array of string): Boolean
      begin
        Result := AIndex > StrIdx;
      end
    );
  end;

begin
  SameOddnessAsFirst := function (const AElem: Integer; const AIndex: Integer;
    const A: array of Integer): Boolean
    var
      FirstOddness: Boolean;
    begin
      Assert(Length(A) > 0);
      FirstOddness := Odd(A[0]);
      Result := Odd(AElem) = FirstOddness;
    end;

  IGot := TArrayUtils.FindAll<Integer>(IA5, SameOddnessAsFirst);
  IExpected := TArray<Integer>.Create(0, 2, 4, 2, 0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I1');

  IGot := TArrayUtils.FindAll<Integer>(IA6, SameOddnessAsFirst);
  IExpected := TArray<Integer>.Create(9, 9, 9, 9, 9, 9);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I2');

  IGot := TArrayUtils.FindAll<Integer>(IA1, SameOddnessAsFirst);
  IExpected := TArray<Integer>.Create(7);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I3');

  SGot := ElementsAfter('six', SA2Rev);
  SExpected := TArray<string>.Create('four', 'two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S1');

  SGot := ElementsAfter('six', SA2);
  SExpected := TArray<string>.Create('eight');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S2');

  SGot := ElementsAfter('eight', SA2);
  SExpected := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S3');

  DistanceGTFirst := function (const AElem: TPoint; const AIndex: Integer;
    const A: array of TPoint): Boolean
    var
      FirstDistance: Extended;
    begin
      Assert(Length(A) > 0);
      FirstDistance := DistFromOrigin(A[0]);
      Result := DistFromOrigin(AElem) > FirstDistance;
    end;

  PGot := TArrayUtils.FindAll<TPoint>(PA2, DistanceGTFirst);
  PExpected := TArray<TPoint>.Create(Pm1p5, Pp12m12, Pm8m9, Pp12p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P1');

  PGot := TArrayUtils.FindAll<TPoint>(PA1, DistanceGTFirst);
  PExpected := TArray<TPoint>.Create();
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P2');
end;

procedure TestTArrayUtils.TestFindAll_SimpleCallback_Overload;
var
  CheckOdd: TArrayUtils.TConstraint<Integer>;
  CheckLongStrs: TArrayUtils.TConstraint<string>;
  CheckDistantPoints: TArrayUtils.TConstraint<TPoint>;
  EI, FI: TArray<Integer>;
  ES, FS: TArray<string>;
  EP, FP: TArray<TPoint>;
  EO, FO: TArray<TTestObj>;
begin
  CheckOdd := function (const I: Integer): Boolean begin Result := Odd(I); end;

  FI := TArrayUtils.FindAll<Integer>(IA3, CheckOdd);
  EI := TArray<Integer>.Create(1, 3, 9);
  CheckTrue(TArrayUtils.Equal<Integer>(EI, FI, IntEqualsFn), 'I1');

  FI := TArrayUtils.FindAll<Integer>(IA6, CheckOdd);
  EI := TArray<Integer>.Create(9, 9, 9, 9, 9, 9);
  CheckTrue(TArrayUtils.Equal<Integer>(EI, FI, IntEqualsFn), 'I2');

  FI := TArrayUtils.FindAll<Integer>(IA2, CheckOdd);
  EI := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(EI, FI, IntEqualsFn), 'I3');

  FI := TArrayUtils.FindAll<Integer>(IA0, CheckOdd);
  EI := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(EI, FI, IntEqualsFn), 'I4');

  CheckLongStrs := function(const S: string): Boolean
    begin
      // "Long" strings have > 3 chars!!
      Result := Length(S) > 3;
    end;

  FS := TArrayUtils.FindAll<string>(SA2, CheckLongStrs);
  ES := TArray<string>.Create('four', 'eight');
  CheckTrue(TArrayUtils.Equal<string>(ES, FS, StrEqualsStrFn), 'S1');

  FS := TArrayUtils.FindAll<string>(SA6, CheckLongStrs);
  ES := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(ES, FS, StrEqualsStrFn), 'S2');

  FS := TArrayUtils.FindAll<string>(SA3, CheckLongStrs);
  ES := TArray<string>.Create('three', 'four', 'nine');
  CheckTrue(TArrayUtils.Equal<string>(ES, FS, StrEqualsStrFn), 'S3');

  FS := TArrayUtils.FindAll<string>(SA0, CheckLongStrs);
  ES := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(ES, FS, StrEqualsStrFn), 'S4');

  CheckDistantPoints := function(const P: TPoint): Boolean
    begin
      // A point is distant (from origin) if its distance >= 5.0
      Result := DistFromOrigin(P) > 5.0;
    end;

  FP := TArrayUtils.FindAll<TPoint>(PA2, CheckDistantPoints);
  EP := TArray<TPoint>.Create(Pm1p5, Pp12m12, Pm8m9, Pp12p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(EP, FP, PointEqualsFn), 'P1');

  FP := TArrayUtils.FindAll<TPoint>(PA2Short, CheckDistantPoints);
  EP := TArray<TPoint>.Create(Pm1p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(EP, FP, PointEqualsFn), 'P2');

  FP := TArrayUtils.FindAll<TPoint>(PA3, CheckDistantPoints);
  EP := TArray<TPoint>.Create(Pm1p5, Pm8m9, Pm8m9, Pm1p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(EP, FP, PointEqualsFn), 'P3');

  FP := TArrayUtils.FindAll<TPoint>(PA1, CheckDistantPoints);
  EP := TArray<TPoint>.Create();
  CheckTrue(TArrayUtils.Equal<TPoint>(EP, FP, PointEqualsFn), 'P4');

  FP := TArrayUtils.FindAll<TPoint>(PA0, CheckDistantPoints);
  EP := TArray<TPoint>.Create();
  CheckTrue(TArrayUtils.Equal<TPoint>(EP, FP, PointEqualsFn), 'P5');

  FO := TArrayUtils.FindAll<TTestObj>(
    OA2,
    function (const AElem: TTestObj): Boolean
    begin
      Result := AElem.B.IndexOf('d') >= 0;
    end
  );
  EO := TArray<TTestObj>.Create(O1, O2, O3);
  CheckTrue(TArrayUtils.Equal<TTestObj>(EO, FO, TestObjEqualsFn), 'O');
end;

procedure TestTArrayUtils.TestFindDef__ExtendedCallback_Overload;
var
  IsPeakElem: TArrayUtils.TConstraintEx<Integer>;
  IsPeakLongestStr: TArrayUtils.TConstraintEx<string>;
  SGot: string;
  IGot: Integer;
begin
  IsPeakElem := function (const AElem: Integer; const AIndex: Integer;
    const A: array of Integer): Boolean
    begin
      if Length(A) = 0 then
        Exit(False);
      if Length(A) = 1 then
        Exit(True);
      // Length(A) >= 2
      if (AIndex = 0) then
        // 1st elem: peak if next elem smaller
        Result := A[Succ(AIndex)] < AElem
      else if AIndex = Pred(Length(A)) then
        // last elem: peak if previous elem smaller
        Result := A[Pred(AIndex)] < AElem
      else
        // not 1st or last: peak if > than elems on either side
        Result := (A[Succ(AIndex)] < AElem) and (A[Pred(AIndex)] < AElem);
    end;

  IGot := TArrayUtils.FindDef<Integer>(IA2, IsPeakElem, 999);
  CheckEquals(8, IGot, 'I1');

  IGot := TArrayUtils.FindDef<Integer>(IA2Rev, IsPeakElem, 999);
  CheckEquals(8, IGot, 'I2');

  IGot := TArrayUtils.FindDef<Integer>(IA5, IsPeakElem, 999);
  CheckEquals(4, IGot, 'I3');

  IGot := TArrayUtils.FindDef<Integer>(IA6, IsPeakElem, 999);
  CheckEquals(999, IGot, 'I4');

  IsPeakLongestStr := function (const AElem: string; const AIndex: Integer;
    const A: array of string): Boolean
    begin
      if Length(A) = 0 then
        Exit(False);
      if Length(A) = 1 then
        Exit(True);
      // Length(A) >= 2
      if (AIndex = 0) then
        // 1st elem: peak if next elem shorter
        Result := Length(A[Succ(AIndex)]) < Length(AElem)
      else if AIndex = Pred(Length(A)) then
        // last elem: peak if previous elem shorter
        Result := Length(A[Pred(AIndex)]) < Length(AElem)
      else
        // not 1st or last: peak if longer than elems on either side
        Result := (Length(A[Succ(AIndex)]) < Length(AElem))
          and (Length(A[Pred(AIndex)]) < Length(AElem));
    end;

  SGot := TArrayUtils.FindDef<string>(SA4, IsPeakLongestStr, '@');
  CheckEquals('three', SGot, 'S1');

  SGot := TArrayUtils.FindDef<string>(SA7, IsPeakLongestStr, '@');
  CheckEquals('three', SGot, 'S2');

  SGot := TArrayUtils.FindDef<string>(SA0, IsPeakLongestStr, '@');
  CheckEquals('@', SGot, 'S3');
end;

procedure TestTArrayUtils.TestFindDef__SimpleCallback_Overload;
var
  IGot: Integer;
  SGot: string;
  PGot: TPoint;
  OGot, ODefault: TTestObj;
begin
  SGot := TArrayUtils.FindDef<string>(
    SA7,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 't'; end,
    '*'
  );
  CheckEquals('three', SGot, 'S1');

  SGot := TArrayUtils.FindDef<string>(
    SA1five,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 'f'; end,
    '*'
  );
  CheckEquals('five', SGot, 'S2');

  SGot := TArrayUtils.FindDef<string>(
    SA1two,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 'f'; end,
    '*'
  );
  CheckEquals('*', SGot, 'S3');

  IGot := TArrayUtils.FindDef<Integer>(
    IA5,
    function (const I: Integer): Boolean begin Result := I > 2; end,
    999
  );
  CheckEquals(3, IGot, 'I1');

  IGot := TArrayUtils.FindDef<Integer>(
    IA0,
    function (const I: Integer): Boolean begin Result := I > 2; end,
    999
  );
  CheckEquals(999, IGot, 'I2');

  IGot := TArrayUtils.FindDef<Integer>(
    IA5,
    function (const I: Integer): Boolean begin Result := I >= 0; end,
    999
  );
  CheckEquals(0, IGot, 'I3');

  IGot := TArrayUtils.FindDef<Integer>(
    IA2,
    function (const I: Integer): Boolean begin Result := Odd(I); end,
    999
  );
  CheckEquals(999, IGot, 'I4');

  PGot := TArrayUtils.FindDef<TPoint>(
    PA2,
    function (const P: TPoint): Boolean
    begin
      // point with distance from origin > 5
      Result := DistFromOrigin(P) > 5.0;
    end,
    Pmissing
  );
  CheckTrue(PointEqualsFn(Pm1p5, PGot), 'P1');

  PGot := TArrayUtils.FindDef<TPoint>(
    PA2,
    function (const P: TPoint): Boolean begin Result := PointEqualsFn(P, Pmissing) end,
    Pmissing
  );
  CheckTrue(PointEqualsFn(Pmissing, PGot), 'P2');

  ODefault := TTestObj.Create('@', TArray<string>.Create());
  try
    OGot := TArrayUtils.FindDef<TTestObj>(
      OATwoPeeks,
      function (const O: TTestObj): Boolean
      begin
        Result := O.B.IndexOf('d') > -1;
      end,
      ODefault
    );
    CheckTrue(O1.Equals(OGot), 'O1');

    OGot := TArrayUtils.FindDef<TTestObj>(
      OATwoPeeks,
      function (const O: TTestObj): Boolean
      begin
        Result := O.A = '?';
      end,
      ODefault
    );
    CheckTrue(ODefault.Equals(OGot), 'O2');
  finally
    ODefault.Free;
  end;
end;

procedure TestTArrayUtils.TestFindIndex_ExtendedCallback_Overload;
var
  IsPeakElem: TArrayUtils.TConstraintEx<Integer>;
  IsPeakLongestStr: TArrayUtils.TConstraintEx<string>;
  Got: Integer;
begin
  IsPeakElem := function (const AElem: Integer; const AIndex: Integer;
    const A: array of Integer): Boolean
    begin
      if Length(A) = 0 then
        Exit(False);
      if Length(A) = 1 then
        Exit(True);
      // Length(A) >= 2
      if (AIndex = 0) then
        // 1st elem: peak if next elem smaller
        Result := A[Succ(AIndex)] < AElem
      else if AIndex = Pred(Length(A)) then
        // last elem: peak if previous elem smaller
        Result := A[Pred(AIndex)] < AElem
      else
        // not 1st or last: peak if > than elems on either side
        Result := (A[Succ(AIndex)] < AElem) and (A[Pred(AIndex)] < AElem);
    end;

  Got := TArrayUtils.FindIndex<Integer>(IA2, IsPeakElem);
  CheckEquals(3, Got, 'I1');

  Got := TArrayUtils.FindIndex<Integer>(IA2Rev, IsPeakElem);
  CheckEquals(0, Got, 'I2');

  Got := TArrayUtils.FindIndex<Integer>(IA5, IsPeakElem);
  CheckEquals(4, Got, 'I3');

  Got := TArrayUtils.FindIndex<Integer>(IA6, IsPeakElem);
  CheckEquals(-1, Got, 'I4');

  Got := TArrayUtils.FindIndex<Integer>(IA7, IsPeakElem);
  CheckEquals(2, Got, 'I5');

  Got := TArrayUtils.FindIndex<Integer>(IA1, IsPeakElem);
  CheckEquals(0, Got, 'I6');

  Got := TArrayUtils.FindIndex<Integer>(IA0, IsPeakElem);
  CheckEquals(-1, Got, 'I7');

  IsPeakLongestStr := function (const AElem: string; const AIndex: Integer;
    const A: array of string): Boolean
    begin
      if Length(A) = 0 then
        Exit(False);
      if Length(A) = 1 then
        Exit(True);
      // Length(A) >= 2
      if (AIndex = 0) then
        // 1st elem: peak if next elem shorter
        Result := Length(A[Succ(AIndex)]) < Length(AElem)
      else if AIndex = Pred(Length(A)) then
        // last elem: peak if previous elem shorter
        Result := Length(A[Pred(AIndex)]) < Length(AElem)
      else
        // not 1st or last: peak if longer than elems on either side
        Result := (Length(A[Succ(AIndex)]) < Length(AElem))
          and (Length(A[Pred(AIndex)]) < Length(AElem));
    end;

  Got := TArrayUtils.FindIndex<string>(SA4, IsPeakLongestStr);
  CheckEquals(1, Got, 'S1');

  Got := TArrayUtils.FindIndex<string>(SA7, IsPeakLongestStr);
  CheckEquals(1, Got, 'S2');

  Got := TArrayUtils.FindIndex<string>(SA2, IsPeakLongestStr);
  CheckEquals(1, Got, 'S3');

  Got := TArrayUtils.FindIndex<string>(SA2Rev, IsPeakLongestStr);
  CheckEquals(0, Got, 'S4');

  Got := TArrayUtils.FindIndex<string>(SA1two, IsPeakLongestStr);
  CheckEquals(0, Got, 'S5');
end;

procedure TestTArrayUtils.TestFindIndex_SimpleCallback_Overload;
var
  Got: Integer;
begin
  Got := TArrayUtils.FindIndex<string>(
    SA7,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 't'; end
  );
  CheckEquals(1, Got, 'S1');

  Got := TArrayUtils.FindIndex<string>(
    SA1five,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 'f'; end
  );
  CheckEquals(0, Got, 'S2');

  Got := TArrayUtils.FindIndex<string>(
    SA1two,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 'f'; end
  );
  CheckEquals(-1, Got, 'S3');

  Got := TArrayUtils.FindIndex<Integer>(
    IA5,
    function (const I: Integer): Boolean begin Result := I > 2; end
  );
  CheckEquals(3, Got, 'I1');

  Got := TArrayUtils.FindIndex<Integer>(
    IA0,
    function (const I: Integer): Boolean begin Result := I > 2; end
  );
  CheckEquals(-1, Got, 'I2');

  Got := TArrayUtils.FindIndex<Integer>(
    IA5,
    function (const I: Integer): Boolean begin Result := I >= 0; end
  );
  CheckEquals(0, Got, 'I3');

  Got := TArrayUtils.FindIndex<Integer>(
    IA2,
    function (const I: Integer): Boolean begin Result := Odd(I); end
  );
  CheckEquals(-1, Got, 'I4');

  Got := TArrayUtils.FindIndex<TPoint>(
    PA2,
    function (const P: TPoint): Boolean
    begin
      // point with distance from origin > 5
      Result := DistFromOrigin(P) > 5.0;
    end
  );
  CheckEquals(2, Got, 'P1');

  Got := TArrayUtils.FindIndex<TPoint>(
    PA2,
    function (const P: TPoint): Boolean begin Result := PointEqualsFn(P, Pmissing) end
  );
  CheckEquals(-1, Got, 'P2');

  Got := TArrayUtils.FindIndex<TTestObj>(
    OATwoPeeks,
    function (const O: TTestObj): Boolean
    begin
      Result := O.B.IndexOf('d') > -1;
    end
  );
  CheckEquals(0, Got, 'O1');

  Got := TArrayUtils.FindIndex<TTestObj>(
    OATwoPeeks,
    function (const O: TTestObj): Boolean
    begin
      Result := O.A = '?';
    end
  );
  CheckEquals(-1, Got, 'O2');
end;

procedure TestTArrayUtils.TestFindLastDef__ExtendedCallback_Overload;
var
  IsPeakElem: TArrayUtils.TConstraintEx<Integer>;
  IsPeakLongestStr: TArrayUtils.TConstraintEx<string>;
  SGot: string;
  IGot: Integer;
begin
  IsPeakElem := function (const AElem: Integer; const AIndex: Integer;
    const A: array of Integer): Boolean
    begin
      if Length(A) = 0 then
        Exit(False);
      if Length(A) = 1 then
        Exit(True);
      // Length(A) >= 2
      if (AIndex = 0) then
        // 1st elem: peak if next elem smaller
        Result := A[Succ(AIndex)] < AElem
      else if AIndex = Pred(Length(A)) then
        // last elem: peak if previous elem smaller
        Result := A[Pred(AIndex)] < AElem
      else
        // not 1st or last: peak if > than elems on either side
        Result := (A[Succ(AIndex)] < AElem) and (A[Pred(AIndex)] < AElem);
    end;

  IGot := TArrayUtils.FindLastDef<Integer>(IA2, IsPeakElem, -1);
  CheckEquals(8, IGot, 'I1');

  IGot := TArrayUtils.FindLastDef<Integer>(IA2Rev, IsPeakElem, -1);
  CheckEquals(8, IGot, 'I2');

  IGot := TArrayUtils.FindLastDef<Integer>(IA5, IsPeakElem, -1);
  CheckEquals(4, IGot, 'I3');

  IGot := TArrayUtils.FindLastDef<Integer>(IA6, IsPeakElem, -1);
  CheckEquals(-1, IGot, 'I4');

  IGot := TArrayUtils.FindLastDef<Integer>(IA7, IsPeakElem, -1);
  CheckEquals(8, IGot, 'I5');

  IGot := TArrayUtils.FindLastDef<Integer>(IA1, IsPeakElem, -1);
  CheckEquals(7, IGot, 'I6');

  IGot := TArrayUtils.FindLastDef<Integer>(IA0, IsPeakElem, -1);
  CheckEquals(-1, IGot, 'I7');

  IsPeakLongestStr := function (const AElem: string; const AIndex: Integer;
    const A: array of string): Boolean
    begin
      if Length(A) = 0 then
        Exit(False);
      if Length(A) = 1 then
        Exit(True);
      // Length(A) >= 2
      if (AIndex = 0) then
        // 1st elem: peak if next elem shorter
        Result := Length(A[Succ(AIndex)]) < Length(AElem)
      else if AIndex = Pred(Length(A)) then
        // last elem: peak if previous elem shorter
        Result := Length(A[Pred(AIndex)]) < Length(AElem)
      else
        // not 1st or last: peak if longer than elems on either side
        Result := (Length(A[Succ(AIndex)]) < Length(AElem))
          and (Length(A[Pred(AIndex)]) < Length(AElem));
    end;

  SGot := TArrayUtils.FindLastDef<string>(SA4, IsPeakLongestStr, '');
  CheckEquals('seven', SGot, 'S1');

  SGot := TArrayUtils.FindLastDef<string>(SA7, IsPeakLongestStr, '');
  CheckEquals('three', SGot, 'S2');

  SGot := TArrayUtils.FindLastDef<string>(SA2, IsPeakLongestStr, '');
  CheckEquals('eight', SGot, 'S3');

  SGot := TArrayUtils.FindLastDef<string>(SA2Rev, IsPeakLongestStr, '');
  CheckEquals('four', SGot, 'S4');

  SGot := TArrayUtils.FindLastDef<string>(SA0, IsPeakLongestStr, '');
  CheckEquals('', SGot, 'S5');
end;

procedure TestTArrayUtils.TestFindLastDef__SimpleCallback_Overload;
var
  SGot: string;
  IGot: Integer;
  PGot: TPoint;
  OGot, ODefault: TTestObj;
begin
  SGot := TArrayUtils.FindLastDef<string>(
    SA7,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 't'; end,
    ''
  );
  CheckEquals('two', SGot, 'S1');

  SGot := TArrayUtils.FindLastDef<string>(
    SA1five,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 'f'; end,
    ''
  );
  CheckEquals('five', SGot, 'S2');

  SGot := TArrayUtils.FindLastDef<string>(
    SA1two,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 'f'; end,
    ''
  );
  CheckEquals('', SGot, 'S3');

  IGot := TArrayUtils.FindLastDef<Integer>(
    IA5,
    function (const I: Integer): Boolean begin Result := I > 2; end,
    -1
  );
  CheckEquals(3, IGot, 'I1');

  IGot := TArrayUtils.FindLastDef<Integer>(
    IA0,
    function (const I: Integer): Boolean begin Result := I > 2; end,
    -1
  );
  CheckEquals(-1, IGot, 'I2');

  IGot := TArrayUtils.FindLastDef<Integer>(
    IA5,
    function (const I: Integer): Boolean begin Result := I >= 0; end,
    -1
  );
  CheckEquals(0, IGot, 'I3');

  IGot := TArrayUtils.FindLastDef<Integer>(
    IA2,
    function (const I: Integer): Boolean begin Result := Odd(I); end,
    -1
  );
  CheckEquals(-1, IGot, 'I4');

  IGot := TArrayUtils.FindLastDef<Integer>(
    IA6,
    function (const I: Integer): Boolean begin Result := not Odd(I); end,
    -1
  );
  CheckEquals(8, IGot, 'I5');

  IGot := TArrayUtils.FindLastDef<Integer>(
    IA6,
    function (const I: Integer): Boolean begin Result := Odd(I); end,
    -1
  );
  CheckEquals(9, IGot, 'I6');

  PGot := TArrayUtils.FindLastDef<TPoint>(
    PA2,
    function (const P: TPoint): Boolean
    begin
      // point with distance from origin > 5
      Result := DistFromOrigin(P) > 5.0;
    end,
    Pmissing
  );
  CheckTrue(PointEqualsFn(Pp12p5, PGot), 'P1');

  PGot := TArrayUtils.FindLastDef<TPoint>(
    PA2,
    function (const P: TPoint): Boolean begin Result := PointEqualsFn(P, Pmissing) end,
    Pmissing
  );
  CheckTrue(PointEqualsFn(Pmissing, PGot), 'P2');

  PGot := TArrayUtils.FindLastDef<TPoint>(
    PA2short,
    function (const P: TPoint): Boolean
    begin
      // point with distance from origin < 3.5
      Result := DistFromOrigin(P) < 3.5;
    end,
    Pmissing
  );
  CheckTrue(PointEqualsFn(Pp1p3Dup, PGot), 'P3');

  ODefault := TTestObj.Create('', TArray<string>.Create());
  try
    OGot := TArrayUtils.FindLastDef<TTestObj>(
      OATwoPeeks,
      function (const O: TTestObj): Boolean
      begin
        Result := O.B.IndexOf('d') > -1;
      end,
      ODefault
    );
    CheckTrue(O2.Equals(OGot), 'O1');

    OGot := TArrayUtils.FindLastDef<TTestObj>(
      OATwoPeeks,
      function (const O: TTestObj): Boolean
      begin
        Result := O.A = '?';
      end,
      ODefault
    );
    CheckTrue(ODefault.Equals(OGot), 'O2');
  finally
    ODefault.Free
  end;
end;

procedure TestTArrayUtils.TestFindLastIndex_ExtendedCallback_Overload;
var
  IsPeakElem: TArrayUtils.TConstraintEx<Integer>;
  IsPeakLongestStr: TArrayUtils.TConstraintEx<string>;
  Got: Integer;
begin
  IsPeakElem := function (const AElem: Integer; const AIndex: Integer;
    const A: array of Integer): Boolean
    begin
      if Length(A) = 0 then
        Exit(False);
      if Length(A) = 1 then
        Exit(True);
      // Length(A) >= 2
      if (AIndex = 0) then
        // 1st elem: peak if next elem smaller
        Result := A[Succ(AIndex)] < AElem
      else if AIndex = Pred(Length(A)) then
        // last elem: peak if previous elem smaller
        Result := A[Pred(AIndex)] < AElem
      else
        // not 1st or last: peak if > than elems on either side
        Result := (A[Succ(AIndex)] < AElem) and (A[Pred(AIndex)] < AElem);
    end;

  Got := TArrayUtils.FindLastIndex<Integer>(IA2, IsPeakElem);
  CheckEquals(3, Got, 'I1');

  Got := TArrayUtils.FindLastIndex<Integer>(IA2Rev, IsPeakElem);
  CheckEquals(0, Got, 'I2');

  Got := TArrayUtils.FindLastIndex<Integer>(IA5, IsPeakElem);
  CheckEquals(4, Got, 'I3');

  Got := TArrayUtils.FindLastIndex<Integer>(IA6, IsPeakElem);
  CheckEquals(-1, Got, 'I4');

  Got := TArrayUtils.FindLastIndex<Integer>(IA7, IsPeakElem);
  CheckEquals(6, Got, 'I5');

  Got := TArrayUtils.FindLastIndex<Integer>(IA1, IsPeakElem);
  CheckEquals(0, Got, 'I6');

  Got := TArrayUtils.FindLastIndex<Integer>(IA0, IsPeakElem);
  CheckEquals(-1, Got, 'I7');

  IsPeakLongestStr := function (const AElem: string; const AIndex: Integer;
    const A: array of string): Boolean
    begin
      if Length(A) = 0 then
        Exit(False);
      if Length(A) = 1 then
        Exit(True);
      // Length(A) >= 2
      if (AIndex = 0) then
        // 1st elem: peak if next elem shorter
        Result := Length(A[Succ(AIndex)]) < Length(AElem)
      else if AIndex = Pred(Length(A)) then
        // last elem: peak if previous elem shorter
        Result := Length(A[Pred(AIndex)]) < Length(AElem)
      else
        // not 1st or last: peak if longer than elems on either side
        Result := (Length(A[Succ(AIndex)]) < Length(AElem))
          and (Length(A[Pred(AIndex)]) < Length(AElem));
    end;

  Got := TArrayUtils.FindLastIndex<string>(SA4, IsPeakLongestStr);
  CheckEquals(3, Got, 'S1');

  Got := TArrayUtils.FindLastIndex<string>(SA7, IsPeakLongestStr);
  CheckEquals(3, Got, 'S2');

  Got := TArrayUtils.FindLastIndex<string>(SA2, IsPeakLongestStr);
  CheckEquals(3, Got, 'S3');

  Got := TArrayUtils.FindLastIndex<string>(SA2Rev, IsPeakLongestStr);
  CheckEquals(2, Got, 'S4');

  Got := TArrayUtils.FindLastIndex<string>(SA1two, IsPeakLongestStr);
  CheckEquals(0, Got, 'S5');
end;

procedure TestTArrayUtils.TestFindLastIndex_SimpleCallback_Overload;
var
  Got: Integer;
begin
  Got := TArrayUtils.FindLastIndex<string>(
    SA7,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 't'; end
  );
  CheckEquals(4, Got, 'S1');

  Got := TArrayUtils.FindLastIndex<string>(
    SA1five,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 'f'; end
  );
  CheckEquals(0, Got, 'S2');

  Got := TArrayUtils.FindLastIndex<string>(
    SA1two,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 'f'; end
  );
  CheckEquals(-1, Got, 'S3');

  Got := TArrayUtils.FindLastIndex<Integer>(
    IA5,
    function (const I: Integer): Boolean begin Result := I > 2; end
  );
  CheckEquals(5, Got, 'I1');

  Got := TArrayUtils.FindLastIndex<Integer>(
    IA0,
    function (const I: Integer): Boolean begin Result := I > 2; end
  );
  CheckEquals(-1, Got, 'I2');

  Got := TArrayUtils.FindLastIndex<Integer>(
    IA5,
    function (const I: Integer): Boolean begin Result := I >= 0; end
  );
  CheckEquals(8, Got, 'I3');

  Got := TArrayUtils.FindLastIndex<Integer>(
    IA2,
    function (const I: Integer): Boolean begin Result := Odd(I); end
  );
  CheckEquals(-1, Got, 'I4');

  Got := TArrayUtils.FindLastIndex<Integer>(
    IA6,
    function (const I: Integer): Boolean begin Result := not Odd(I); end
  );
  CheckEquals(3, Got, 'I5');

  Got := TArrayUtils.FindLastIndex<Integer>(
    IA6,
    function (const I: Integer): Boolean begin Result := Odd(I); end
  );
  CheckEquals(6, Got, 'I6');

  Got := TArrayUtils.FindLastIndex<TPoint>(
    PA2,
    function (const P: TPoint): Boolean
    begin
      // point with distance from origin > 5
      Result := DistFromOrigin(P) > 5.0;
    end
  );
  CheckEquals(5, Got, 'P1');

  Got := TArrayUtils.FindLastIndex<TPoint>(
    PA2,
    function (const P: TPoint): Boolean begin Result := PointEqualsFn(P, Pmissing) end
  );
  CheckEquals(-1, Got, 'P2');

  Got := TArrayUtils.FindLastIndex<TPoint>(
    PA2short,
    function (const P: TPoint): Boolean
    begin
      // point with distance from origin < 3.5
      Result := DistFromOrigin(P) < 3.5;
    end
  );
  CheckEquals(1, Got, 'P3');

  Got := TArrayUtils.FindLastIndex<TTestObj>(
    OATwoPeeks,
    function (const O: TTestObj): Boolean
    begin
      Result := O.B.IndexOf('d') > -1;
    end
  );
  CheckEquals(6, Got, 'O1');

  Got := TArrayUtils.FindLastIndex<TTestObj>(
    OATwoPeeks,
    function (const O: TTestObj): Boolean
    begin
      Result := O.A = '?';
    end
  );
  CheckEquals(-1, Got, 'O2');
end;

procedure TestTArrayUtils.TestFirst;
begin
  CheckEquals(7, TArrayUtils.First<Integer>(IA1), 'I1');
  CheckEquals(1, TArrayUtils.First<Integer>(IA3), 'I2');
  CheckEquals(2, TArrayUtils.First<Integer>(IA2), 'I3');

  CheckEquals('two', TArrayUtils.First<string>(SA1two), 'S1');
  CheckEquals('one', TArrayUtils.First<string>(SA3), 'S2');

  CheckTrue(PointEqualsFn(Pp1p3, TArrayUtils.First<TPoint>(PA2)), 'P');

  CheckTrue(TestObjEqualsFn(O4, TArrayUtils.First<TTestObj>(OA3)), 'O');

  CheckException(First_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestForEach_ExtendedCallback_Overload;
var
  RevInts, ExpectedRevInts: TArray<Integer>;
  UniqueStrs, ExpectedUniqueStrs: TArray<string>;
  Dists, ExpectedDists: TArray<Extended>;

  // Reverse an integer array
  function Reverse(const IA: array of Integer): TArray<Integer>;
  var
    OutArr: TArray<Integer>;
  begin
    SetLength(OutArr, Length(IA));
    TArrayUtils.ForEach<Integer>(
      IA,
      procedure(const I: Integer; const AIndex: Integer; const A: array of Integer)
      begin
        OutArr[Length(A) - AIndex - 1] := I;
      end
    );
    Result := OutArr;
  end;

  // Return list of words that occur exactly once in a string array
  function UniqueWords(const Strs: array of string): TArray<string>;
  var
    List: TList<string>;
  begin
    List := TList<string>.Create;
    try
      TArrayUtils.ForEach<string> (
        Strs,
        procedure(const S: string; const AIndex: Integer; const A: array of string)
        var
          Idx: Integer;
          Count: Integer;
        begin
          Count := 0;
          for Idx := 0 to Pred(Length(A)) do
          begin
            if A[Idx] = S then
              Inc(Count);
          end;
          if Count = 1 then
            List.Add(S);
        end
      );
      Result := List.ToArray;
    finally
      List.Free;
    end;
  end;

  // Returns an array of distances between consecutive points in an array
  function PointDistances(const Pts: array of TPoint): TArray<Extended>;
  var
    OutArr: TArray<Extended>;
  begin
    Assert(Length(Pts) >= 2); // make no sense with < 2 points
    SetLength(OutArr, Length(Pts) - 1);
    TArrayUtils.ForEach<TPoint>(
      Pts,
      procedure(const PA: TPoint; const AIndex: Integer; const A: array of TPoint)
      var
        Distance: Extended;
        PB: TPoint;
      begin
        if AIndex = 0 then
          Exit;
        PB := A[Pred(AIndex)];
        Distance := Sqrt(Sqr(PA.X - PB.X) + Sqr(PA.Y - PB.Y));
        OutArr[Pred(AIndex)] := Distance;
      end
    );
    Result := OutArr;
  end;

begin
  RevInts := Reverse(IA2);
  ExpectedRevInts := IA2Rev;
  CheckTrue(TArrayUtils.Equal<Integer>(ExpectedRevInts, RevInts), 'I1');

  RevInts := Reverse(IA6);
  ExpectedRevInts := IA6;
  CheckTrue(TArrayUtils.Equal<Integer>(ExpectedRevInts, RevInts), 'I2');

  RevInts := Reverse(IA0);
  ExpectedRevInts := IA0;
  CheckTrue(TArrayUtils.Equal<Integer>(ExpectedRevInts, RevInts), 'I3');

  UniqueStrs := UniqueWords(SA1five);
  ExpectedUniqueStrs := TArray<string>.Create('five');
  CheckTrue(TArrayUtils.Equal<string>(ExpectedUniqueStrs, UniqueStrs, StrEqualsStrFn), 'S1');

  UniqueStrs := UniqueWords(SA2);
  ExpectedUniqueStrs := SA2;
  CheckTrue(TArrayUtils.Equal<string>(ExpectedUniqueStrs, UniqueStrs, StrEqualsStrFn), 'S2');

  UniqueStrs := UniqueWords(SA6);
  ExpectedUniqueStrs := TArray<string>.Create('two');
  CheckTrue(TArrayUtils.Equal<string>(ExpectedUniqueStrs, UniqueStrs, StrEqualsStrFn), 'S3');

  UniqueStrs := UniqueWords(SA7);
  ExpectedUniqueStrs := TArray<string>.Create('five', 'two');
  CheckTrue(TArrayUtils.Equal<string>(ExpectedUniqueStrs, UniqueStrs, StrEqualsStrFn), 'S4');

  UniqueStrs := UniqueWords(SA5);
  ExpectedUniqueStrs := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(ExpectedUniqueStrs, UniqueStrs, StrEqualsStrFn), 'S5');

  UniqueStrs := UniqueWords(SA0);
  ExpectedUniqueStrs := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(ExpectedUniqueStrs, UniqueStrs, StrEqualsStrFn), 'S6');

  // Expected resulted calculated at https://tinyurl.com/yej2w3bz
  ExpectedDists := TArray<Extended>.Create(2.8284271247462, 15.652475842499, 0.0, 15.652475842499, 2.8284271247462);
  Dists := PointDistances(PA3);
  CheckTrue(TArrayUtils.Equal<Extended>(ExpectedDists, Dists, ExtendedEqualsFn), 'P1');

  ExpectedDists := TArray<Extended>.Create(0.0, 2.8284271247462, 21.400934559033, 20.223748416157, 24.413111231467);
  Dists := PointDistances(PA2);
  CheckTrue(TArrayUtils.Equal<Extended>(ExpectedDists, Dists, ExtendedEqualsFn), 'P2');

  ExpectedDists := TArray<Extended>.Create(15.0, 15.652475842499);
  Dists := PointDistances(PA4);
  CheckTrue(TArrayUtils.Equal<Extended>(ExpectedDists, Dists, ExtendedEqualsFn), 'P3');
end;

procedure TestTArrayUtils.TestForEach_SimpleCallback_Overload;
var
  LowerStrs, ExpectedLowerStrs: TArray<string>;
  DistanceBands, ExpectedDistanceBands: TArray<Integer>;

  function PointDistanceBands(const Pts: array of TPoint): TArray<Integer>;
  var
    List: TList<Integer>;
  begin
    List := TList<Integer>.Create;
    try
      TArrayUtils.ForEach<TPoint>(
        Pts,
        procedure (const P: TPoint)
        begin
          List.Add(Round(DistFromOrigin(P)));
        end
      );
      Result := List.ToArray;
    finally
      List.Free;
    end;
  end;

  function LoCaseStrs(const Strs: array of string): TArray<string>;
  var
    List: TList<string>;
  begin
    List := TList<string>.Create;
    try
      TArrayUtils.ForEach<string>(
        Strs,
        procedure (const S: string)
        begin
          if S = LowerCase(S) then
            List.Add(S);
        end
      );
      Result := List.ToArray;
    finally
      List.Free;
    end;
  end;

  function Sum(const IA: array of Integer): Integer;
  var
    Res: Integer;
  begin
    Res := 0;
    TArrayUtils.ForEach<Integer>(
      IA,
      procedure (const I: Integer)
      begin
        Inc(Res, I);
      end
    );
    Result := Res;
  end;

begin
  CheckEquals(20, Sum(IA2), 'I1');
  CheckEquals(62, Sum(IA6), 'I2');
  CheckEquals(0, Sum(IA0), 'I3');

  ExpectedLowerStrs := SA2;
  LowerStrs := LoCaseStrs(SA2);
  CheckTrue(TArrayUtils.Equal<string>(ExpectedLowerStrs, LowerStrs), 'S1');

  ExpectedLowerStrs := SA1five;
  LowerStrs := LoCaseStrs(SA1five);
  CheckTrue(TArrayUtils.Equal<string>(ExpectedLowerStrs, LowerStrs), 'S2');

  ExpectedLowerStrs := TArray<string>.Create('two');
  LowerStrs := LoCaseStrs(SA2DupIgnoreCase);
  CheckTrue(TArrayUtils.Equal<string>(ExpectedLowerStrs, LowerStrs), 'S3');

  ExpectedLowerStrs := TArray<string>.Create();
  LowerStrs := LoCaseStrs(SA0);
  CheckTrue(TArrayUtils.Equal<string>(ExpectedLowerStrs, LowerStrs), 'S4');

  ExpectedDistanceBands := TArray<Integer>.Create(3, 5, 12, 12, 5, 3);
  DistanceBands := PointDistanceBands(PA3);
  CheckTrue(TArrayUtils.Equal<Integer>(ExpectedDistanceBands, DistanceBands), 'P1');

  ExpectedDistanceBands := TArray<Integer>.Create(3, 12, 5);
  DistanceBands := PointDistanceBands(PA4);
  CheckTrue(TArrayUtils.Equal<Integer>(ExpectedDistanceBands, DistanceBands), 'P2');

  ExpectedDistanceBands := TArray<Integer>.Create(3);
  DistanceBands := PointDistanceBands(PA1);
  CheckTrue(TArrayUtils.Equal<Integer>(ExpectedDistanceBands, DistanceBands), 'P3');

  ExpectedDistanceBands := TArray<Integer>.Create();
  DistanceBands := PointDistanceBands(PA0);
  CheckTrue(TArrayUtils.Equal<Integer>(ExpectedDistanceBands, DistanceBands), 'P4');

end;

procedure TestTArrayUtils.TestIndexOf_ComparerFunc_Overload;
begin
  CheckEquals(-1, TArrayUtils.IndexOf<Integer>(42, IA0, IntEqualsFn), 'I1');
  CheckEquals(-1, TArrayUtils.IndexOf<Integer>(4, IA4, IntEqualsFn), 'I2');
  CheckEquals(2, TArrayUtils.IndexOf<Integer>(4, IA3, IntEqualsFn), 'I3');
  CheckEquals(0, TArrayUtils.IndexOf<Integer>(1, IA3, IntEqualsFn), 'I4');
  CheckEquals(4, TArrayUtils.IndexOf<Integer>(9, IA4, IntEqualsFn), 'I5');
  CheckEquals(2, TArrayUtils.IndexOf<Integer>(2, IA5, IntEqualsFn), 'I6');
  CheckEquals(0, TArrayUtils.IndexOf<Integer>(9, IA6, IntEqualsFn), 'I7');
  CheckEquals(4, TArrayUtils.IndexOf<Integer>(4, IA5, IntEqualsFn), 'I8');
  CheckEquals(1, TArrayUtils.IndexOf<Integer>(1, IA5, IntEqualsFn), 'I9');

  CheckEquals(-1, TArrayUtils.IndexOf<string>('nine', SA0, StrEqualsStrFn), 'S1');
  CheckEquals(-1, TArrayUtils.IndexOf<string>('four', SA2DupIgnoreCase, StrEqualsStrFn), 'S2');
  CheckEquals(1, TArrayUtils.IndexOf<string>('four', SA2, StrEqualsStrFn), 'S3');
  CheckEquals(0, TArrayUtils.IndexOf<string>('one', SA4, StrEqualsStrFn), 'S4');
  CheckEquals(-1, TArrayUtils.IndexOf<string>('ONE', SA4, StrEqualsStrFn), 'S5');
  CheckEquals(1, TArrayUtils.IndexOf<string>('two', SA5, StrEqualsStrFn), 'S6');
  CheckEquals(0, TArrayUtils.IndexOf<string>('one', SA6, StrEqualsStrFn), 'S7');

  CheckEquals(-1, TArrayUtils.IndexOf<string>('nine', SA0, StrEqualsTextFn), 'T1');
  CheckEquals(1, TArrayUtils.IndexOf<string>('four', SA2DupIgnoreCase, StrEqualsTextFn), 'T2');
  CheckEquals(1, TArrayUtils.IndexOf<string>('four', SA2, StrEqualsTextFn), 'T3');
  CheckEquals(4, TArrayUtils.IndexOf<string>('nine', SA3, StrEqualsTextFn), 'T4');
  CheckEquals(4, TArrayUtils.IndexOf<string>('NINE', SA3, StrEqualsTextFn), 'T5');
  CheckEquals(1, TArrayUtils.IndexOf<string>('TWO', SA5, StrEqualsTextFn), 'T6');
  CheckEquals(0, TArrayUtils.IndexOf<string>('One', SA6, StrEqualsTextFn), 'T7');

  CheckEquals(2, TArrayUtils.IndexOf<TPoint>(Pm1p5, PA2, PointEqualsFn), 'P1');
  CheckEquals(-1, TArrayUtils.IndexOf<TPoint>(Pmissing, PA2, PointEqualsFn), 'P2');
  CheckEquals(-1, TArrayUtils.IndexOf<TPoint>(Pm1p5, PA0, PointEqualsFn), 'P3');
  CheckEquals(1, TArrayUtils.IndexOf<TPoint>(Pm1p5, PA3, PointEqualsFn), 'P4');

  CheckEquals(1, TArrayUtils.IndexOf<TTestObj>(O2Dup, OA2, TestObjEqualsFn), 'O1');
  CheckEquals(1, TArrayUtils.IndexOf<TTestObj>(O2Dup, OA2Dup, TestObjEqualsFn), 'O2');
end;

procedure TestTArrayUtils.TestIndexOf_ComparerObj_Overload;
begin
  CheckEquals(-1, TArrayUtils.IndexOf<Integer>(42, IA0, IntegerEqualityComparer), 'I1');
  CheckEquals(-1, TArrayUtils.IndexOf<Integer>(4, IA4, IntegerEqualityComparer), 'I2');
  CheckEquals(2, TArrayUtils.IndexOf<Integer>(4, IA3, IntegerEqualityComparer), 'I3');
  CheckEquals(0, TArrayUtils.IndexOf<Integer>(1, IA3, IntegerEqualityComparer), 'I4');
  CheckEquals(4, TArrayUtils.IndexOf<Integer>(9, IA4, IntegerEqualityComparer), 'I5');
  CheckEquals(2, TArrayUtils.IndexOf<Integer>(2, IA5, IntegerEqualityComparer), 'I6');
  CheckEquals(0, TArrayUtils.IndexOf<Integer>(9, IA6, IntegerEqualityComparer), 'I7');
  CheckEquals(4, TArrayUtils.IndexOf<Integer>(4, IA5, IntegerEqualityComparer), 'I8');
  CheckEquals(1, TArrayUtils.IndexOf<Integer>(1, IA5, IntegerEqualityComparer), 'I9');

  CheckEquals(-1, TArrayUtils.IndexOf<string>('nine', SA0, StringEqualityComparer), 'S1');
  CheckEquals(-1, TArrayUtils.IndexOf<string>('four', SA2DupIgnoreCase, StringEqualityComparer), 'S2');
  CheckEquals(1, TArrayUtils.IndexOf<string>('four', SA2, StringEqualityComparer), 'S3');
  CheckEquals(0, TArrayUtils.IndexOf<string>('one', SA4, StringEqualityComparer), 'S4');
  CheckEquals(-1, TArrayUtils.IndexOf<string>('ONE', SA4, StringEqualityComparer), 'S5');
  CheckEquals(1, TArrayUtils.IndexOf<string>('two', SA5, StringEqualityComparer), 'S6');
  CheckEquals(0, TArrayUtils.IndexOf<string>('one', SA6, StringEqualityComparer), 'S7');

  CheckEquals(-1, TArrayUtils.IndexOf<string>('nine', SA0, TextEqualityComparer), 'T1');
  CheckEquals(1, TArrayUtils.IndexOf<string>('four', SA2DupIgnoreCase, TextEqualityComparer), 'T2');
  CheckEquals(1, TArrayUtils.IndexOf<string>('four', SA2, TextEqualityComparer), 'T3');
  CheckEquals(4, TArrayUtils.IndexOf<string>('nine', SA3, TextEqualityComparer), 'T4');
  CheckEquals(4, TArrayUtils.IndexOf<string>('NINE', SA3, TextEqualityComparer), 'T5');
  CheckEquals(1, TArrayUtils.IndexOf<string>('TWO', SA5, TextEqualityComparer), 'T6');
  CheckEquals(0, TArrayUtils.IndexOf<string>('One', SA6, TextEqualityComparer), 'T7');

  CheckEquals(2, TArrayUtils.IndexOf<TPoint>(Pm1p5, PA2, PointEqualityComparer), 'P1');
  CheckEquals(-1, TArrayUtils.IndexOf<TPoint>(Pmissing, PA2, PointEqualityComparer), 'P2');
  CheckEquals(-1, TArrayUtils.IndexOf<TPoint>(Pm1p5, PA0, PointEqualityComparer), 'P3');
  CheckEquals(1, TArrayUtils.IndexOf<TPoint>(Pm1p5, PA3, PointEqualityComparer), 'P4');

  CheckEquals(1, TArrayUtils.IndexOf<TTestObj>(O2Dup, OA2, TestObjEqualityComparer), 'O1');
  CheckEquals(1, TArrayUtils.IndexOf<TTestObj>(O2Dup, OA2Dup, TestObjEqualityComparer), 'O2');
end;

procedure TestTArrayUtils.TestIndexOf_NilComparer_Overload;
begin
  CheckEquals(-1, TArrayUtils.IndexOf<Integer>(42, IA0), 'I1');
  CheckEquals(-1, TArrayUtils.IndexOf<Integer>(4, IA4), 'I2');
  CheckEquals(2, TArrayUtils.IndexOf<Integer>(4, IA3), 'I3');
  CheckEquals(0, TArrayUtils.IndexOf<Integer>(1, IA3), 'I4');
  CheckEquals(4, TArrayUtils.IndexOf<Integer>(9, IA4), 'I5');
  CheckEquals(2, TArrayUtils.IndexOf<Integer>(2, IA5), 'I6');
  CheckEquals(0, TArrayUtils.IndexOf<Integer>(9, IA6), 'I7');
  CheckEquals(4, TArrayUtils.IndexOf<Integer>(4, IA5), 'I8');
  CheckEquals(1, TArrayUtils.IndexOf<Integer>(1, IA5), 'I9');

  CheckEquals(-1, TArrayUtils.IndexOf<string>('nine', SA0), 'S1');
  CheckEquals(-1, TArrayUtils.IndexOf<string>('four', SA2DupIgnoreCase), 'S2');
  CheckEquals(1, TArrayUtils.IndexOf<string>('four', SA2), 'S3');
  CheckEquals(0, TArrayUtils.IndexOf<string>('one', SA4), 'S4');
  CheckEquals(-1, TArrayUtils.IndexOf<string>('ONE', SA4), 'S5');
  CheckEquals(1, TArrayUtils.IndexOf<string>('two', SA5), 'S6');
  CheckEquals(0, TArrayUtils.IndexOf<string>('one', SA6), 'S7');

  CheckEquals(2, TArrayUtils.IndexOf<TPoint>(Pm1p5, PA2), 'P1');
  CheckEquals(-1, TArrayUtils.IndexOf<TPoint>(Pmissing, PA2), 'P2');
  CheckEquals(-1, TArrayUtils.IndexOf<TPoint>(Pm1p5, PA0), 'P3');
  CheckEquals(1, TArrayUtils.IndexOf<TPoint>(Pm1p5, PA3), 'P4');

  CheckEquals(-1, TArrayUtils.IndexOf<TTestObj>(O2Dup, OA2), 'O1');
  CheckEquals(1, TArrayUtils.IndexOf<TTestObj>(O2Dup, OA2Dup), 'O2');
end;

procedure TestTArrayUtils.TestIndicesOf_ComparerFunc_Overload;
var
  Got, Expected: TArray<Integer>;
begin
  Got := TArrayUtils.IndicesOf<Integer>(0, IA0, IntEqualsFn);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I1');
  Got := TArrayUtils.IndicesOf<Integer>(0, IA2, IntEqualsFn);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I2');
  Got := TArrayUtils.IndicesOf<Integer>(4, IA2, IntEqualsFn);
  Expected := TArray<Integer>.Create(1);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I3');
  Got := TArrayUtils.IndicesOf<Integer>(9, IA6, IntEqualsFn);
  Expected := TArray<Integer>.Create(0, 1, 2, 4, 5, 6);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I4');
  Got := TArrayUtils.IndicesOf<Integer>(4, IA5, IntEqualsFn);
  Expected := TArray<Integer>.Create(4);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I5');
  Got := TArrayUtils.IndicesOf<Integer>(0, IA5, IntEqualsFn);
  Expected := TArray<Integer>.Create(0, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I6');

  Got := TArrayUtils.IndicesOf<string>('four', SA2, StrEqualsStrFn);
  Expected := TArray<Integer>.Create(1);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S1');
  Got := TArrayUtils.IndicesOf<string>('five', SA2, StrEqualsStrFn);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S2');
  Got := TArrayUtils.IndicesOf<string>('six', SA2DupIgnoreCase, StrEqualsTextFn);
  Expected := TArray<Integer>.Create(2);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S3');
  Got := TArrayUtils.IndicesOf<string>('one', SA6, StrEqualsStrFn);
  Expected := TArray<Integer>.Create(0, 1, 3, 4, 5);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S4');
  Got := TArrayUtils.IndicesOf<string>('three', SA7, StrEqualsStrFn);
  Expected := TArray<Integer>.Create(1, 3);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S5');

  Got := TArrayUtils.IndicesOf<TPoint>(Pp1p3, PA1, PointEqualsFn);
  Expected := TArray<Integer>.Create(0);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P1');
  Got := TArrayUtils.IndicesOf<TPoint>(Pp1p3, PA2, PointEqualsFn);
  Expected := TArray<Integer>.Create(0,1);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P2');
  Got := TArrayUtils.IndicesOf<TPoint>(Pm8m9, PA3, PointEqualsFn);
  Expected := TArray<Integer>.Create(2,3);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P3');
  Got := TArrayUtils.IndicesOf<TPoint>(Pmissing, PA3, PointEqualsFn);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P4');

  Got := TArrayUtils.IndicesOf<TTestObj>(O2, OA2Dup, TestObjEqualsFn);
  Expected := TArray<Integer>.Create(1);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'O1');
  Got := TArrayUtils.IndicesOf<TTestObj>(O2, OATwoPeeks, TestObjEqualsFn);
  Expected := TArray<Integer>.Create(1,3,6);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'O2');
  Got := TArrayUtils.IndicesOf<TTestObj>(O1, OA3, TestObjEqualsFn);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'O3');
end;

procedure TestTArrayUtils.TestIndicesOf_ComparerObj_Overload;
var
  Got, Expected: TArray<Integer>;
begin
  Got := TArrayUtils.IndicesOf<Integer>(0, IA0, IntegerEqualityComparer);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I1');
  Got := TArrayUtils.IndicesOf<Integer>(0, IA2, IntegerEqualityComparer);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I2');
  Got := TArrayUtils.IndicesOf<Integer>(4, IA2, IntegerEqualityComparer);
  Expected := TArray<Integer>.Create(1);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I3');
  Got := TArrayUtils.IndicesOf<Integer>(9, IA6, IntegerEqualityComparer);
  Expected := TArray<Integer>.Create(0, 1, 2, 4, 5, 6);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I4');
  Got := TArrayUtils.IndicesOf<Integer>(4, IA5, IntegerEqualityComparer);
  Expected := TArray<Integer>.Create(4);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I5');
  Got := TArrayUtils.IndicesOf<Integer>(0, IA5, IntegerEqualityComparer);
  Expected := TArray<Integer>.Create(0, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I6');

  Got := TArrayUtils.IndicesOf<string>('four', SA2, StringEqualityComparer);
  Expected := TArray<Integer>.Create(1);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S1');
  Got := TArrayUtils.IndicesOf<string>('five', SA2, StringEqualityComparer);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S2');
  Got := TArrayUtils.IndicesOf<string>('six', SA2DupIgnoreCase, TextEqualityComparer);
  Expected := TArray<Integer>.Create(2);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S3');
  Got := TArrayUtils.IndicesOf<string>('one', SA6, StringEqualityComparer);
  Expected := TArray<Integer>.Create(0, 1, 3, 4, 5);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S4');
  Got := TArrayUtils.IndicesOf<string>('three', SA7, StringEqualityComparer);
  Expected := TArray<Integer>.Create(1, 3);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S5');

  Got := TArrayUtils.IndicesOf<TPoint>(Pp1p3, PA1, PointEqualityComparer);
  Expected := TArray<Integer>.Create(0);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P1');
  Got := TArrayUtils.IndicesOf<TPoint>(Pp1p3, PA2, PointEqualityComparer);
  Expected := TArray<Integer>.Create(0,1);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P2');
  Got := TArrayUtils.IndicesOf<TPoint>(Pm8m9, PA3, PointEqualityComparer);
  Expected := TArray<Integer>.Create(2,3);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P3');
  Got := TArrayUtils.IndicesOf<TPoint>(Pmissing, PA3, PointEqualityComparer);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'P4');

  Got := TArrayUtils.IndicesOf<TTestObj>(O2, OA2Dup, TestObjEqualityComparer);
  Expected := TArray<Integer>.Create(1);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'O1');
  Got := TArrayUtils.IndicesOf<TTestObj>(O2, OATwoPeeks, TestObjEqualityComparer);
  Expected := TArray<Integer>.Create(1,3,6);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'O2');
  Got := TArrayUtils.IndicesOf<TTestObj>(O1, OA3, TestObjEqualityComparer);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'O3');
end;

procedure TestTArrayUtils.TestIndicesOf_NilComparer_Overload;
var
  Got, Expected: TArray<Integer>;
begin
  Got := TArrayUtils.IndicesOf<Integer>(0, IA0);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I1');
  Got := TArrayUtils.IndicesOf<Integer>(0, IA2);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I2');
  Got := TArrayUtils.IndicesOf<Integer>(4, IA2);
  Expected := TArray<Integer>.Create(1);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I3');
  Got := TArrayUtils.IndicesOf<Integer>(9, IA6);
  Expected := TArray<Integer>.Create(0, 1, 2, 4, 5, 6);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I4');
  Got := TArrayUtils.IndicesOf<Integer>(4, IA5);
  Expected := TArray<Integer>.Create(4);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I5');
  Got := TArrayUtils.IndicesOf<Integer>(0, IA5);
  Expected := TArray<Integer>.Create(0, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'I6');

  Got := TArrayUtils.IndicesOf<string>('four', SA2);
  Expected := TArray<Integer>.Create(1);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S1');
  Got := TArrayUtils.IndicesOf<string>('five', SA2);
  Expected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S2');
  Got := TArrayUtils.IndicesOf<string>('one', SA6);
  Expected := TArray<Integer>.Create(0, 1, 3, 4, 5);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S3');
  Got := TArrayUtils.IndicesOf<string>('three', SA7);
  Expected := TArray<Integer>.Create(1, 3);
  CheckTrue(TArrayUtils.Equal<Integer>(Expected, Got), 'S4');
end;

procedure TestTArrayUtils.TestInsert_Array_Overload;
var
  IA, IExpected: TArray<Integer>;
  SA, SExpected: TArray<string>;
  PA, PExpected: TArray<TPoint>;
  OA, OExpected: TArray<TTestObj>;
begin
  // Insert non-empty array in middle of non-empty array
  IA := Copy(IA2);
  TArrayUtils.Insert<Integer>(IA, IA3, 2);
  IExpected := TArray<Integer>.Create(2, 4, 1, 3, 4, 6, 9, 6, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1');

  // Insert non-empty array before start of a non-empty array
  IA := Copy(IA2);
  TArrayUtils.Insert<Integer>(IA, IA3, 0);
  IExpected := TArray<Integer>.Create(1, 3, 4, 6, 9, 2, 4, 6, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2');

  // Insert non-empty array at end of a non-empty array
  IA := Copy(IA2);
  TArrayUtils.Insert<Integer>(IA, IA3, Length(IA));
  IExpected := TArray<Integer>.Create(2, 4, 6, 8, 1, 3, 4, 6, 9);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3');

  // Insert array into itself
  IA := Copy(IA2);
  TArrayUtils.Insert<Integer>(IA, IA, 1);
  IExpected := TArray<Integer>.Create(2, 2, 4, 6, 8, 4, 6, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I4');

  // Insert empty array into non-empty array
  IA := Copy(IA2);
  TArrayUtils.Insert<Integer>(IA, IA0, 2);
  IExpected := TArray<Integer>.Create(2, 4, 6, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I5');

  // Insert non-empty array into empty array
  SetLength(IA, 0);
  TArrayUtils.Insert<Integer>(IA, IA2, 0);
  IExpected := TArray<Integer>.Create(2, 4, 6, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I6');

  // Insert empty array into empty array
  SetLength(IA, 0);
  TArrayUtils.Insert<Integer>(IA, IA0, 0);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I7');

  // Insert non-empty array at end of single element array
  IA := Copy(IA1);
  TArrayUtils.Insert<Integer>(IA, IA2, 1);
  IExpected := TArray<Integer>.Create(7, 2, 4, 6, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I8');

  // Insert non-empty array at start of single element array
  IA := Copy(IA1);
  TArrayUtils.Insert<Integer>(IA, IA2, 0);
  IExpected := TArray<Integer>.Create(2, 4, 6, 8, 7);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I9');

  // Insert single element array within multiple element array
  SA := Copy(SA3);
  TArrayUtils.Insert<string>(SA, SA1five, 3);
  SExpected := TArray<string>.Create('one', 'three', 'four', 'five', 'six', 'nine');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA, StrEqualsStrFn), 'S1');

  // Insert whole array at start of itself, using a negative index that should
  // be adjusted to 0.
  SA := Copy(SA3);
  TArrayUtils.Insert<string>(SA, SA3, -7);
  SExpected := TArray<string>.Create('one', 'three', 'four', 'six', 'nine', 'one', 'three', 'four', 'six', 'nine');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA, StrEqualsStrFn), 'S2');

  // Insert single element array at end of another array using an index that
  // lies beyond the end of the target array, that should be modified to
  // Length(SA)
  SA := Copy(SA3);
  TArrayUtils.Insert<string>(SA, SA1five, 99);
  SExpected := TArray<string>.Create('one', 'three', 'four', 'six', 'nine', 'five');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA, StrEqualsStrFn), 'S3');

  PA := Copy(PA3);
  TArrayUtils.Insert<TPoint>(PA, PA4, 2);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pm1p5, Pp1p3, Pm8m9, Pm1p5, Pm8m9, Pm8m9, Pm1p5, Pp1p3);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA, PointEqualsFn), 'P1');

  PA := Copy(PA3);
  TArrayUtils.Insert<TPoint>(PA, PA4, Length(PA3));
  PExpected := TArray<TPoint>.Create(Pp1p3, Pm1p5, Pm8m9, Pm8m9, Pm1p5, Pp1p3, Pp1p3, Pm8m9, Pm1p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA, PointEqualsFn), 'P2');

  PA := Copy(PA3);
  TArrayUtils.Insert<TPoint>(PA, PA4, 0);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pm8m9, Pm1p5, Pp1p3, Pm1p5, Pm8m9, Pm8m9, Pm1p5, Pp1p3);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA, PointEqualsFn), 'P3');

  OA := Copy(OA3);
  TArrayUtils.Insert<TTestObj>(OA, OA1, 1);
  OExpected := TArray<TTestObj>.Create(O4, O1, O5, O3, O2);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA), 'O');
end;

procedure TestTArrayUtils.TestInsert_SingleElem_Overload;
var
  IA, IExpected: TArray<Integer>;
  SA, SExpected: TArray<string>;
  PA, PExpected: TArray<TPoint>;
  OA, OExpected: TArray<TTestObj>;
begin
  IA := Copy(IA0);
  TArrayUtils.Insert<Integer>(IA, 9, 0);
  IExpected := TArray<Integer>.Create(9);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1');

  TArrayUtils.Insert<Integer>(IA, 8, 0);
  IExpected := TArray<Integer>.Create(8, 9);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2');

  TArrayUtils.Insert<Integer>(IA, 7, 2);
  IExpected := TArray<Integer>.Create(8, 9, 7);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3');

  TArrayUtils.Insert<Integer>(IA, 6, 2);
  IExpected := TArray<Integer>.Create(8, 9, 6, 7);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I4');

  TArrayUtils.Insert<Integer>(IA, 5, 2);
  IExpected := TArray<Integer>.Create(8, 9, 5, 6, 7);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I5');

  SA := Copy(SA2);
  TArrayUtils.Insert<string>(SA, 'five', 3);
  SExpected := TArray<string>.Create('two', 'four', 'six', 'five', 'eight');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S1');

  SA := Copy(SA2);
  TArrayUtils.Insert<string>(SA, 'five', -1);
  SExpected := TArray<string>.Create('five', 'two', 'four', 'six', 'eight');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S2');

  SA := Copy(SA2);
  TArrayUtils.Insert<string>(SA, 'five', 99);
  SExpected := TArray<string>.Create('two', 'four', 'six', 'eight', 'five');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S3');

  SA := Copy(SA0);
  TArrayUtils.Insert<string>(SA, 'five', 0);
  SExpected := TArray<string>.Create('five');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S4');

  PA := Copy(PA4);
  TArrayUtils.Insert<TPoint>(PA, Pmissing, 1);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pmissing, Pm8m9, Pm1p5);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA), 'P');

  OA := Copy(OA3);
  TArrayUtils.Insert<TTestObj>(OA, O1, 2);
  OExpected := TArray<TTestObj>.Create(O4, O5, O1, O3, O2);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA), 'O');
end;

procedure TestTArrayUtils.TestLast;
begin
  CheckEquals(7, TArrayUtils.Last<Integer>(IA1), 'I1');
  CheckEquals(9, TArrayUtils.Last<Integer>(IA3), 'I2');
  CheckEquals(8, TArrayUtils.Last<Integer>(IA2), 'I3');

  CheckEquals('Eight', TArrayUtils.Last<string>(SA2DupIgnoreCase), 'S1');
  CheckEquals('eight', TArrayUtils.Last<string>(SA2), 'S2');

  CheckTrue(PointEqualsFn(Pp12p5, TArrayUtils.Last<TPoint>(PA2)), 'P');

  CheckTrue(TestObjEqualsFn(O2, TArrayUtils.Last<TTestObj>(OA3)), 'O');

  CheckException(Last_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestLastIndexOf_ComparerFunc_Overload;
begin
  CheckEquals(-1, TArrayUtils.LastIndexOf<Integer>(42, IA0, IntEqualsFn), 'I1');
  CheckEquals(-1, TArrayUtils.LastIndexOf<Integer>(4, IA4, IntEqualsFn), 'I2');
  CheckEquals(2, TArrayUtils.LastIndexOf<Integer>(4, IA3, IntEqualsFn), 'I3');
  CheckEquals(0, TArrayUtils.LastIndexOf<Integer>(1, IA3, IntEqualsFn), 'I4');
  CheckEquals(4, TArrayUtils.LastIndexOf<Integer>(9, IA4, IntEqualsFn), 'I5');
  CheckEquals(6, TArrayUtils.LastIndexOf<Integer>(2, IA5, IntEqualsFn), 'I6');
  CheckEquals(6, TArrayUtils.LastIndexOf<Integer>(9, IA6, IntEqualsFn), 'I7');
  CheckEquals(4, TArrayUtils.LastIndexOf<Integer>(4, IA5, IntEqualsFn), 'I8');
  CheckEquals(7, TArrayUtils.LastIndexOf<Integer>(1, IA5, IntEqualsFn), 'I9');

  CheckEquals(-1, TArrayUtils.LastIndexOf<string>('nine', SA0, StrEqualsStrFn), 'S1');
  CheckEquals(-1, TArrayUtils.LastIndexOf<string>('four', SA2DupIgnoreCase, StrEqualsStrFn), 'S2');
  CheckEquals(1, TArrayUtils.LastIndexOf<string>('four', SA2, StrEqualsStrFn), 'S3');
  CheckEquals(0, TArrayUtils.LastIndexOf<string>('one', SA4, StrEqualsStrFn), 'S4');
  CheckEquals(-1, TArrayUtils.LastIndexOf<string>('ONE', SA4, StrEqualsStrFn), 'S5');
  CheckEquals(3, TArrayUtils.LastIndexOf<string>('two', SA5, StrEqualsStrFn), 'S6');
  CheckEquals(5, TArrayUtils.LastIndexOf<string>('one', SA6, StrEqualsStrFn), 'S7');
  CheckEquals(2, TArrayUtils.LastIndexOf<string>('one', SA5, StrEqualsStrFn), 'S8');

  CheckEquals(-1, TArrayUtils.LastIndexOf<string>('nine', SA0, StrEqualsTextFn), 'T1');
  CheckEquals(1, TArrayUtils.LastIndexOf<string>('four', SA2DupIgnoreCase, StrEqualsTextFn), 'T2');
  CheckEquals(1, TArrayUtils.LastIndexOf<string>('four', SA2, StrEqualsTextFn), 'T3');
  CheckEquals(4, TArrayUtils.LastIndexOf<string>('nine', SA3, StrEqualsTextFn), 'T4');
  CheckEquals(4, TArrayUtils.LastIndexOf<string>('NINE', SA3, StrEqualsTextFn), 'T5');
  CheckEquals(3, TArrayUtils.LastIndexOf<string>('TWO', SA5, StrEqualsTextFn), 'T6');
  CheckEquals(5, TArrayUtils.LastIndexOf<string>('One', SA6, StrEqualsTextFn), 'T7');
  CheckEquals(2, TArrayUtils.LastIndexOf<string>('one', SA5, StrEqualsTextFn), 'T8');

  CheckEquals(2, TArrayUtils.LastIndexOf<TPoint>(Pm1p5, PA2, PointEqualsFn), 'P1');
  CheckEquals(-1, TArrayUtils.LastIndexOf<TPoint>(Pmissing, PA2, PointEqualsFn), 'P2');
  CheckEquals(-1, TArrayUtils.LastIndexOf<TPoint>(Pm1p5, PA0, PointEqualsFn), 'P3');
  CheckEquals(4, TArrayUtils.LastIndexOf<TPoint>(Pm1p5, PA3, PointEqualsFn), 'P4');
  CheckEquals(5, TArrayUtils.LastIndexOf<TPoint>(Pp1p3, PA3, PointEqualsFn), 'P5');

  CheckEquals(4, TArrayUtils.LastIndexOf<TTestObj>(O3, OATwoPeeks, TestObjEqualsFn), 'O1');
  CheckEquals(1, TArrayUtils.LastIndexOf<TTestObj>(O2, OA2Dup, TestObjEqualsFn), 'O2');
end;

procedure TestTArrayUtils.TestLastIndexOf_ComparerObj_Overload;
begin
  CheckEquals(-1, TArrayUtils.LastIndexOf<Integer>(42, IA0, IntegerEqualityComparer), 'I1');
  CheckEquals(-1, TArrayUtils.LastIndexOf<Integer>(4, IA4, IntegerEqualityComparer), 'I2');
  CheckEquals(2, TArrayUtils.LastIndexOf<Integer>(4, IA3, IntegerEqualityComparer), 'I3');
  CheckEquals(0, TArrayUtils.LastIndexOf<Integer>(1, IA3, IntegerEqualityComparer), 'I4');
  CheckEquals(4, TArrayUtils.LastIndexOf<Integer>(9, IA4, IntegerEqualityComparer), 'I5');
  CheckEquals(6, TArrayUtils.LastIndexOf<Integer>(2, IA5, IntegerEqualityComparer), 'I6');
  CheckEquals(6, TArrayUtils.LastIndexOf<Integer>(9, IA6, IntegerEqualityComparer), 'I7');
  CheckEquals(4, TArrayUtils.LastIndexOf<Integer>(4, IA5, IntegerEqualityComparer), 'I8');
  CheckEquals(7, TArrayUtils.LastIndexOf<Integer>(1, IA5, IntegerEqualityComparer), 'I9');

  CheckEquals(-1, TArrayUtils.LastIndexOf<string>('nine', SA0, StringEqualityComparer), 'S1');
  CheckEquals(-1, TArrayUtils.LastIndexOf<string>('four', SA2DupIgnoreCase, StringEqualityComparer), 'S2');
  CheckEquals(1, TArrayUtils.LastIndexOf<string>('four', SA2, StringEqualityComparer), 'S3');
  CheckEquals(0, TArrayUtils.LastIndexOf<string>('one', SA4, StringEqualityComparer), 'S4');
  CheckEquals(-1, TArrayUtils.LastIndexOf<string>('ONE', SA4, StringEqualityComparer), 'S5');
  CheckEquals(3, TArrayUtils.LastIndexOf<string>('two', SA5, StringEqualityComparer), 'S6');
  CheckEquals(5, TArrayUtils.LastIndexOf<string>('one', SA6, StringEqualityComparer), 'S7');
  CheckEquals(2, TArrayUtils.LastIndexOf<string>('one', SA5, StringEqualityComparer), 'S8');

  CheckEquals(-1, TArrayUtils.LastIndexOf<string>('nine', SA0, TextEqualityComparer), 'T1');
  CheckEquals(1, TArrayUtils.LastIndexOf<string>('four', SA2DupIgnoreCase, TextEqualityComparer), 'T2');
  CheckEquals(1, TArrayUtils.LastIndexOf<string>('four', SA2, TextEqualityComparer), 'T3');
  CheckEquals(4, TArrayUtils.LastIndexOf<string>('nine', SA3, TextEqualityComparer), 'T4');
  CheckEquals(4, TArrayUtils.LastIndexOf<string>('NINE', SA3, TextEqualityComparer), 'T5');
  CheckEquals(3, TArrayUtils.LastIndexOf<string>('TWO', SA5, TextEqualityComparer), 'T6');
  CheckEquals(5, TArrayUtils.LastIndexOf<string>('One', SA6, TextEqualityComparer), 'T7');
  CheckEquals(2, TArrayUtils.LastIndexOf<string>('one', SA5, TextEqualityComparer), 'T8');

  CheckEquals(2, TArrayUtils.LastIndexOf<TPoint>(Pm1p5, PA2, PointEqualityComparer), 'P1');
  CheckEquals(-1, TArrayUtils.LastIndexOf<TPoint>(Pmissing, PA2, PointEqualityComparer), 'P2');
  CheckEquals(-1, TArrayUtils.LastIndexOf<TPoint>(Pm1p5, PA0, PointEqualityComparer), 'P3');
  CheckEquals(4, TArrayUtils.LastIndexOf<TPoint>(Pm1p5, PA3, PointEqualityComparer), 'P4');
  CheckEquals(5, TArrayUtils.LastIndexOf<TPoint>(Pp1p3, PA3, PointEqualityComparer), 'P5');

  CheckEquals(4, TArrayUtils.LastIndexOf<TTestObj>(O3, OATwoPeeks, TestObjEqualityComparer), 'O1');
  CheckEquals(1, TArrayUtils.LastIndexOf<TTestObj>(O2, OA2Dup, TestObjEqualityComparer), 'O2');
end;

procedure TestTArrayUtils.TestLastIndexOf_NilComparer_Overload;
begin
  CheckEquals(-1, TArrayUtils.LastIndexOf<Integer>(42, IA0), 'I1');
  CheckEquals(-1, TArrayUtils.LastIndexOf<Integer>(4, IA4), 'I2');
  CheckEquals(2, TArrayUtils.LastIndexOf<Integer>(4, IA3), 'I3');
  CheckEquals(0, TArrayUtils.LastIndexOf<Integer>(1, IA3), 'I4');
  CheckEquals(4, TArrayUtils.LastIndexOf<Integer>(9, IA4), 'I5');
  CheckEquals(6, TArrayUtils.LastIndexOf<Integer>(2, IA5), 'I6');
  CheckEquals(6, TArrayUtils.LastIndexOf<Integer>(9, IA6), 'I7');
  CheckEquals(4, TArrayUtils.LastIndexOf<Integer>(4, IA5), 'I8');
  CheckEquals(7, TArrayUtils.LastIndexOf<Integer>(1, IA5), 'I9');

  CheckEquals(-1, TArrayUtils.LastIndexOf<string>('nine', SA0), 'S1');
  CheckEquals(-1, TArrayUtils.LastIndexOf<string>('four', SA2DupIgnoreCase), 'S2');
  CheckEquals(1, TArrayUtils.LastIndexOf<string>('four', SA2), 'S3');
  CheckEquals(0, TArrayUtils.LastIndexOf<string>('one', SA4), 'S4');
  CheckEquals(-1, TArrayUtils.LastIndexOf<string>('ONE', SA4), 'S5');
  CheckEquals(3, TArrayUtils.LastIndexOf<string>('two', SA5), 'S6');
  CheckEquals(5, TArrayUtils.LastIndexOf<string>('one', SA6), 'S7');
  CheckEquals(2, TArrayUtils.LastIndexOf<string>('one', SA5), 'S8');

  CheckEquals(2, TArrayUtils.LastIndexOf<TPoint>(Pm1p5, PA2), 'P1');
  CheckEquals(-1, TArrayUtils.LastIndexOf<TPoint>(Pmissing, PA2), 'P2');
  CheckEquals(-1, TArrayUtils.LastIndexOf<TPoint>(Pm1p5, PA0), 'P3');
  CheckEquals(4, TArrayUtils.LastIndexOf<TPoint>(Pm1p5, PA3), 'P4');
  CheckEquals(5, TArrayUtils.LastIndexOf<TPoint>(Pp1p3, PA3), 'P5');

  CheckEquals(4, TArrayUtils.LastIndexOf<TTestObj>(O3, OATwoPeeks), 'O1');
  CheckEquals(-1, TArrayUtils.LastIndexOf<TTestObj>(O2, OA2Dup), 'O2');
end;

procedure TestTArrayUtils.TestMax_ComparerFunc_Overload;
var
  S: TArray<string>;
begin
  S := TArray<string>.Create('A', 'B', 'd', 'E');

  CheckEquals(7, TArrayUtils.Max<Integer>(IA1, IntCompareFn), 'I1');
  CheckEquals(8, TArrayUtils.Max<Integer>(IA2, IntCompareFn), 'I2');
  CheckEquals(8, TArrayUtils.Max<Integer>(IA2Rev, IntCompareFn), 'I3');
  CheckEquals(4, TArrayUtils.Max<Integer>(IA5, IntCompareFn), 'I4');
  CheckEquals(9, TArrayUtils.Max<Integer>(IA6, IntCompareFn), 'I5');

  CheckEquals('two', TArrayUtils.Max<string>(SA2, StrCompareStrFn), 'S1');
  CheckEquals('two', TArrayUtils.Max<string>(SA2Rev, StrCompareStrFn), 'S2');
  CheckEquals('three', TArrayUtils.Max<string>(SA3, StrCompareStrFn), 'S3');
  CheckEquals('two', TArrayUtils.Max<string>(SA6, StrCompareStrFn), 'S4');
  CheckEquals('d', TArrayUtils.Max<string>(S, StrCompareStrFn), 'S5a');
  CheckEquals('E', TArrayUtils.Max<string>(S, StrCompareTextFn), 'S5b');

  CheckTrue(PointEqualsFn(Pp12p5, TArrayUtils.Max<TPoint>(PA2, PointCompareFn)), 'P1');
  CheckTrue(PointEqualsFn(Pp1p3, TArrayUtils.Max<TPoint>(PA2Short, PointCompareFn)), 'P2a');
  CheckTrue(PointEqualsFn(Pp1p3Dup, TArrayUtils.Max<TPoint>(PA2Short, PointCompareFn)), 'P2b');

  CheckTrue(TestObjEqualsFn(O5, TArrayUtils.Max<TTestObj>(OA2, TestObjCompareFn)), 'O');

  CheckException(Max_ComparerFunc_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestMax_ComparerObj_Overload;
var
  S: TArray<string>;
begin
  S := TArray<string>.Create('A', 'B', 'd', 'E');

  CheckEquals(7, TArrayUtils.Max<Integer>(IA1, IntegerComparer), 'I1');
  CheckEquals(8, TArrayUtils.Max<Integer>(IA2, IntegerComparer), 'I2');
  CheckEquals(8, TArrayUtils.Max<Integer>(IA2Rev, IntegerComparer), 'I3');
  CheckEquals(4, TArrayUtils.Max<Integer>(IA5, IntegerComparer), 'I4');
  CheckEquals(9, TArrayUtils.Max<Integer>(IA6, IntegerComparer), 'I5');

  CheckEquals('two', TArrayUtils.Max<string>(SA2, StringComparer), 'S1');
  CheckEquals('two', TArrayUtils.Max<string>(SA2Rev, StringComparer), 'S2');
  CheckEquals('three', TArrayUtils.Max<string>(SA3, StringComparer), 'S3');
  CheckEquals('two', TArrayUtils.Max<string>(SA6, StringComparer), 'S4');
  CheckEquals('d', TArrayUtils.Max<string>(S, StringComparer), 'S5a');
  CheckEquals('E', TArrayUtils.Max<string>(S, TextComparer), 'S5b');

  CheckTrue(PointEqualsFn(Pp12p5, TArrayUtils.Max<TPoint>(PA2, PointComparer)), 'P1');
  CheckTrue(PointEqualsFn(Pp1p3, TArrayUtils.Max<TPoint>(PA2Short, PointComparer)), 'P2a');
  CheckTrue(PointEqualsFn(Pp1p3Dup, TArrayUtils.Max<TPoint>(PA2Short, PointComparer)), 'P2b');

  CheckTrue(TestObjEqualsFn(O5, TArrayUtils.Max<TTestObj>(OA2, TestObjComparer)), 'O');

  CheckException(Max_ComparerObj_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestMax_NilComparer_Overload;
var
  S: TArray<string>;
begin
  S := TArray<string>.Create('A', 'B', 'd', 'E');

  CheckEquals(7, TArrayUtils.Max<Integer>(IA1), 'I1');
  CheckEquals(8, TArrayUtils.Max<Integer>(IA2), 'I2');
  CheckEquals(8, TArrayUtils.Max<Integer>(IA2Rev), 'I3');
  CheckEquals(4, TArrayUtils.Max<Integer>(IA5), 'I4');
  CheckEquals(9, TArrayUtils.Max<Integer>(IA6), 'I5');

  CheckEquals('two', TArrayUtils.Max<string>(SA2), 'S1');
  CheckEquals('two', TArrayUtils.Max<string>(SA2Rev), 'S2');
  CheckEquals('three', TArrayUtils.Max<string>(SA3), 'S3');
  CheckEquals('two', TArrayUtils.Max<string>(SA6), 'S4');
  CheckEquals('d', TArrayUtils.Max<string>(S), 'S5');

  // No TPoint overload tests: the default comparer can't be relied upon

  CheckException(Max_NilComparer_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestMinMax_ComparerFunc_Overload;
var
  S: TArray<string>;
  IntMin, IntMax: Integer;
  StrMin, StrMax: string;
  PointMin, PointMax: TPoint;
  TestObjMin, TestObjMax: TTestObj;
begin
  S := TArray<string>.Create('a', 'B', 'd', 'E');

  TArrayUtils.MinMax<Integer>(IA1, IntCompareFn, IntMin, IntMax);
  CheckEquals(7, IntMin, 'I1 min');
  CheckEquals(7, IntMax, 'I1 max');
  TArrayUtils.MinMax<Integer>(IA2, IntCompareFn, IntMin, IntMax);
  CheckEquals(2, IntMin, 'I2 min');
  CheckEquals(8, IntMax, 'I2 max');
  TArrayUtils.MinMax<Integer>(IA2Rev, IntCompareFn, IntMin, IntMax);
  CheckEquals(2, IntMin, 'I3 min');
  CheckEquals(8, IntMax, 'I3 max');
  TArrayUtils.MinMax<Integer>(IA5, IntCompareFn, IntMin, IntMax);
  CheckEquals(0, IntMin, 'I4 min');
  CheckEquals(4, IntMax, 'I4 max');
  TArrayUtils.MinMax<Integer>(IA6, IntCompareFn, IntMin, IntMax);
  CheckEquals(8, IntMin, 'I5 min');
  CheckEquals(9, IntMax, 'I5 max');

  TArrayUtils.MinMax<string>(SA2, StrCompareStrFn, StrMin, StrMax);
  CheckEquals('eight', StrMin, 'S1 min');
  CheckEquals('two', StrMax, 'S1 max');
  TArrayUtils.MinMax<string>(SA2Rev, StrCompareStrFn, StrMin, StrMax);
  CheckEquals('eight', StrMin, 'S2 min');
  CheckEquals('two', StrMax, 'S2 max');
  TArrayUtils.MinMax<string>(SA3, StrCompareStrFn, StrMin, StrMax);
  CheckEquals('four', StrMin, 'S3 min');
  CheckEquals('three', StrMax, 'S3 max');
  TArrayUtils.MinMax<string>(SA6, StrCompareStrFn, StrMin, StrMax);
  CheckEquals('one', StrMin, 'S4 min');
  CheckEquals('two', StrMax, 'S4 max');
  TArrayUtils.MinMax<string>(S, StrCompareStrFn, StrMin, StrMax);
  CheckEquals('B', StrMin, 'S5 min');
  CheckEquals('d', StrMax, 'S5 max');
  TArrayUtils.MinMax<string>(S, StrCompareTextFn, StrMin, StrMax);
  CheckEquals('a', StrMin, 'S6 min');
  CheckEquals('E', StrMax, 'S6 max');

  TArrayUtils.MinMax<TPoint>(PA2, PointCompareFn, PointMin, PointMax);
  CheckTrue(PointEqualsFn(Pp12p5, PointMax), 'P1 max');
  CheckTrue(PointEqualsFn(Pm8m9, PointMin), 'P1 min');

  TArrayUtils.MinMax<TPoint>(PA2Short, PointCompareFn, PointMin, PointMax);
  CheckTrue(PointEqualsFn(Pp1p3, PointMax), 'P2 max');
  CheckTrue(PointEqualsFn(Pm1p5, PointMin), 'P2 min');

  TArrayUtils.MinMax<TTestObj>(OA2, TestObjCompareFn, TestObjMin, TestObjMax);
  CheckTrue(TestObjEqualsFn(O4, TestObjMin), 'O max');
  CheckTrue(TestObjEqualsFn(O5, TestObjMax), 'O min');

  CheckException(MinMax_ComparerFunc_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestMinMax_ComparerObj_Overload;
var
  S: TArray<string>;
  IntMin, IntMax: Integer;
  StrMin, StrMax: string;
  PointMin, PointMax: TPoint;
  TestObjMin, TestObjMax: TTestObj;
begin
  S := TArray<string>.Create('a', 'B', 'd', 'E');

  TArrayUtils.MinMax<Integer>(IA1, IntegerComparer, IntMin, IntMax);
  CheckEquals(7, IntMin, 'I1 min');
  CheckEquals(7, IntMax, 'I1 max');
  TArrayUtils.MinMax<Integer>(IA2, IntegerComparer, IntMin, IntMax);
  CheckEquals(2, IntMin, 'I2 min');
  CheckEquals(8, IntMax, 'I2 max');
  TArrayUtils.MinMax<Integer>(IA2Rev, IntegerComparer, IntMin, IntMax);
  CheckEquals(2, IntMin, 'I3 min');
  CheckEquals(8, IntMax, 'I3 max');
  TArrayUtils.MinMax<Integer>(IA5, IntegerComparer, IntMin, IntMax);
  CheckEquals(0, IntMin, 'I4 min');
  CheckEquals(4, IntMax, 'I4 max');
  TArrayUtils.MinMax<Integer>(IA6, IntegerComparer, IntMin, IntMax);
  CheckEquals(8, IntMin, 'I5 min');
  CheckEquals(9, IntMax, 'I5 max');

  TArrayUtils.MinMax<string>(SA2, StringComparer, StrMin, StrMax);
  CheckEquals('eight', StrMin, 'S1 min');
  CheckEquals('two', StrMax, 'S1 max');
  TArrayUtils.MinMax<string>(SA2Rev, StringComparer, StrMin, StrMax);
  CheckEquals('eight', StrMin, 'S2 min');
  CheckEquals('two', StrMax, 'S2 max');
  TArrayUtils.MinMax<string>(SA3, StringComparer, StrMin, StrMax);
  CheckEquals('four', StrMin, 'S3 min');
  CheckEquals('three', StrMax, 'S3 max');
  TArrayUtils.MinMax<string>(SA6, StringComparer, StrMin, StrMax);
  CheckEquals('one', StrMin, 'S4 min');
  CheckEquals('two', StrMax, 'S4 max');
  TArrayUtils.MinMax<string>(S, StringComparer, StrMin, StrMax);
  CheckEquals('B', StrMin, 'S5 min');
  CheckEquals('d', StrMax, 'S5 max');
  TArrayUtils.MinMax<string>(S, TextComparer, StrMin, StrMax);
  CheckEquals('a', StrMin, 'S6 min');
  CheckEquals('E', StrMax, 'S6 max');

  TArrayUtils.MinMax<TPoint>(PA2, PointComparer, PointMin, PointMax);
  CheckTrue(PointEqualsFn(Pp12p5, PointMax), 'P1 max');
  CheckTrue(PointEqualsFn(Pm8m9, PointMin), 'P1 min');
  TArrayUtils.MinMax<TPoint>(PA2Short, PointComparer, PointMin, PointMax);
  CheckTrue(PointEqualsFn(Pp1p3, PointMax), 'P2 max');
  CheckTrue(PointEqualsFn(Pm1p5, PointMin), 'P2 min');

  TArrayUtils.MinMax<TTestObj>(OA2, TestObjCompareFn, TestObjMin, TestObjMax);
  CheckTrue(TestObjEqualsFn(O4, TestObjMin), 'O max');
  CheckTrue(TestObjEqualsFn(O5, TestObjMax), 'O min');

  CheckException(MinMax_ComparerObj_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestMinMax_NilComparer_Overload;
var
  S: TArray<string>;
  IntMin, IntMax: Integer;
  StrMin, StrMax: string;
begin
  S := TArray<string>.Create('a', 'B', 'd', 'E');

  TArrayUtils.MinMax<Integer>(IA1, IntMin, IntMax);
  CheckEquals(7, IntMin, 'I1 min');
  CheckEquals(7, IntMax, 'I1 max');
  TArrayUtils.MinMax<Integer>(IA2, IntMin, IntMax);
  CheckEquals(2, IntMin, 'I2 min');
  CheckEquals(8, IntMax, 'I2 max');
  TArrayUtils.MinMax<Integer>(IA2Rev, IntMin, IntMax);
  CheckEquals(2, IntMin, 'I3 min');
  CheckEquals(8, IntMax, 'I3 max');
  TArrayUtils.MinMax<Integer>(IA5, IntMin, IntMax);
  CheckEquals(0, IntMin, 'I4 min');
  CheckEquals(4, IntMax, 'I4 max');
  TArrayUtils.MinMax<Integer>(IA6, IntMin, IntMax);
  CheckEquals(8, IntMin, 'I5 min');
  CheckEquals(9, IntMax, 'I5 max');

  TArrayUtils.MinMax<string>(SA2, StrMin, StrMax);
  CheckEquals('eight', StrMin, 'S1 min');
  CheckEquals('two', StrMax, 'S1 max');
  TArrayUtils.MinMax<string>(SA2Rev, StrMin, StrMax);
  CheckEquals('eight', StrMin, 'S2 min');
  CheckEquals('two', StrMax, 'S2 max');
  TArrayUtils.MinMax<string>(SA3, StrMin, StrMax);
  CheckEquals('four', StrMin, 'S3 min');
  CheckEquals('three', StrMax, 'S3 max');
  TArrayUtils.MinMax<string>(SA6, StrMin, StrMax);
  CheckEquals('one', StrMin, 'S4 min');
  CheckEquals('two', StrMax, 'S4 max');
  TArrayUtils.MinMax<string>(S, StrMin, StrMax);
  CheckEquals('B', StrMin, 'S5 min');
  CheckEquals('d', StrMax, 'S5 max');

  // No TPoint overload tests: the default comparer can't be relied upon

  CheckException(MinMax_NilComparer_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestMin_ComparerFunc_Overload;
var
  S: TArray<string>;
begin
  CheckEquals(7, TArrayUtils.Min<Integer>(IA1, IntCompareFn), 'I1');
  CheckEquals(2, TArrayUtils.Min<Integer>(IA2, IntCompareFn), 'I2');
  CheckEquals(2, TArrayUtils.Min<Integer>(IA2Rev, IntCompareFn), 'I3');
  CheckEquals(0, TArrayUtils.Min<Integer>(IA5, IntCompareFn), 'I4');
  CheckEquals(8, TArrayUtils.Min<Integer>(IA6, IntCompareFn), 'I5');

  CheckEquals('eight', TArrayUtils.Min<string>(SA2, StrCompareStrFn), 'S1');
  CheckEquals('eight', TArrayUtils.Min<string>(SA2Rev, StrCompareStrFn), 'S2');
  CheckEquals('four', TArrayUtils.Min<string>(SA3, StrCompareStrFn), 'S3');
  CheckEquals('one', TArrayUtils.Min<string>(SA6, StrCompareStrFn), 'S4');
  S := TArray<string>.Create('a', 'B', 'd', 'E');
  CheckEquals('B', TArrayUtils.Min<string>(S, StrCompareStrFn), 'S5a');
  CheckEquals('a', TArrayUtils.Min<string>(S, StrCompareTextFn), 'S5b');

  CheckTrue(PointEqualsFn(Pm8m9, TArrayUtils.Min<TPoint>(PA2, PointCompareFn)), 'P1');
  CheckTrue(PointEqualsFn(Pm1p5, TArrayUtils.Min<TPoint>(PA2Short, PointCompareFn)), 'P2');

  CheckTrue(TestObjEqualsFn(O4, TArrayUtils.Min<TTestObj>(OA2, TestObjCompareFn)), 'O');

  CheckException(Min_ComparerFunc_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestMin_ComparerObj_Overload;
var
  S: TArray<string>;
begin
  S := TArray<string>.Create('a', 'B', 'd', 'E');

  CheckEquals(7, TArrayUtils.Min<Integer>(IA1, IntegerComparer), 'I1');
  CheckEquals(2, TArrayUtils.Min<Integer>(IA2, IntegerComparer), 'I2');
  CheckEquals(2, TArrayUtils.Min<Integer>(IA2Rev, IntegerComparer), 'I3');
  CheckEquals(0, TArrayUtils.Min<Integer>(IA5, IntegerComparer), 'I4');
  CheckEquals(8, TArrayUtils.Min<Integer>(IA6, IntegerComparer), 'I5');

  CheckEquals('eight', TArrayUtils.Min<string>(SA2, StringComparer), 'S1');
  CheckEquals('eight', TArrayUtils.Min<string>(SA2Rev, StringComparer), 'S2');
  CheckEquals('four', TArrayUtils.Min<string>(SA3, StringComparer), 'S3');
  CheckEquals('one', TArrayUtils.Min<string>(SA6, StringComparer), 'S4');
  CheckEquals('B', TArrayUtils.Min<string>(S, StringComparer), 'S5a');
  CheckEquals('a', TArrayUtils.Min<string>(S, TextComparer), 'S5b');

  CheckTrue(PointEqualsFn(Pm8m9, TArrayUtils.Min<TPoint>(PA2, PointComparer)), 'P1');
  CheckTrue(PointEqualsFn(Pm1p5, TArrayUtils.Min<TPoint>(PA2Short, PointComparer)), 'P2');

  CheckTrue(TestObjEqualsFn(O4, TArrayUtils.Min<TTestObj>(OA2, TestObjComparer)), 'O');

  CheckException(Min_ComparerObj_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestMin_NilComparer_Overload;
var
  S: TArray<string>;
begin
  CheckEquals(7, TArrayUtils.Min<Integer>(IA1), 'I1');
  CheckEquals(2, TArrayUtils.Min<Integer>(IA2), 'I2');
  CheckEquals(2, TArrayUtils.Min<Integer>(IA2Rev), 'I3');
  CheckEquals(0, TArrayUtils.Min<Integer>(IA5), 'I4');
  CheckEquals(8, TArrayUtils.Min<Integer>(IA6), 'I5');

  CheckEquals('eight', TArrayUtils.Min<string>(SA2), 'S1');
  CheckEquals('eight', TArrayUtils.Min<string>(SA2Rev), 'S2');
  CheckEquals('four', TArrayUtils.Min<string>(SA3), 'S3');
  CheckEquals('one', TArrayUtils.Min<string>(SA6), 'S4');
  S := TArray<string>.Create('a', 'B', 'd', 'E');
  CheckEquals('B', TArrayUtils.Min<string>(S), 'S5');

  // No TPoint overload tests: the default comparer can't be relied upon

  CheckException(Min_NilComparer_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestOccurrencesOf_ComparerFunc_Overload;
begin
  CheckEquals(1, TArrayUtils.OccurrencesOf<Integer>(4, IA2, IntEqualsFn), 'I1');
  CheckEquals(0, TArrayUtils.OccurrencesOf<Integer>(5, IA2, IntEqualsFn), 'I2');
  CheckEquals(6, TArrayUtils.OccurrencesOf<Integer>(9, IA6, IntEqualsFn), 'I3');
  CheckEquals(0, TArrayUtils.OccurrencesOf<Integer>(4, IA1, IntEqualsFn), 'I4');
  CheckEquals(1, TArrayUtils.OccurrencesOf<Integer>(7, IA1, IntEqualsFn), 'I5');

  CheckEquals(1, TArrayUtils.OccurrencesOf<string>('two', SA2, StrEqualsStrFn), 'S1');
  CheckEquals(1, TArrayUtils.OccurrencesOf<string>('eight', SA2, StrEqualsStrFn), 'S2');
  CheckEquals(0, TArrayUtils.OccurrencesOf<string>('nine', SA2, StrEqualsStrFn), 'S3');
  CheckEquals(5, TArrayUtils.OccurrencesOf<string>('one', SA6, StrEqualsStrFn), 'S4');
  CheckEquals(0, TArrayUtils.OccurrencesOf<string>('nine', SA0, StrEqualsStrFn), 'S5');
  CheckEquals(0, TArrayUtils.OccurrencesOf<string>('four', SA2DupIgnoreCase, StrEqualsStrFn), 'S6');

  CheckEquals(1, TArrayUtils.OccurrencesOf<string>('two', SA2, StrEqualsTextFn), 'T1');
  CheckEquals(1, TArrayUtils.OccurrencesOf<string>('EIGHT', SA2, StrEqualsTextFn), 'T2');
  CheckEquals(0, TArrayUtils.OccurrencesOf<string>('nine', SA2, StrEqualsTextFn), 'T3');
  CheckEquals(5, TArrayUtils.OccurrencesOf<string>('one', SA6, StrEqualsTextFn), 'T4');
  CheckEquals(0, TArrayUtils.OccurrencesOf<string>('nine', SA0, StrEqualsTextFn), 'T5');
  CheckEquals(1, TArrayUtils.OccurrencesOf<string>('four', SA2DupIgnoreCase, StrEqualsTextFn), 'T6');

  CheckEquals(1, TArrayUtils.OccurrencesOf<TPoint>(Pp1p3, PA4, PointEqualsFn), 'P1');
  CheckEquals(0, TArrayUtils.OccurrencesOf<TPoint>(Pp12m12, PA4, PointEqualsFn), 'P2');
  CheckEquals(2, TArrayUtils.OccurrencesOf<TPoint>(Pp1p3, PA2, PointEqualsFn), 'P3');

  CheckEquals(3, TArrayUtils.OccurrencesOf<TTestObj>(O2, OATwoPeeks, TestObjEqualsFn), 'O1');
  CheckEquals(1, TArrayUtils.OccurrencesOf<TTestObj>(O2, OA2Dup, TestObjEqualsFn), 'O2');
  CheckEquals(0, TArrayUtils.OccurrencesOf<TTestObj>(O1, OA3, TestObjEqualsFn), 'O3');
end;

procedure TestTArrayUtils.TestOccurrencesOf_ComparerObj_Overload;
begin
  CheckEquals(1, TArrayUtils.OccurrencesOf<Integer>(4, IA2, IntegerEqualityComparer), 'I1');
  CheckEquals(0, TArrayUtils.OccurrencesOf<Integer>(5, IA2, IntegerEqualityComparer), 'I2');
  CheckEquals(6, TArrayUtils.OccurrencesOf<Integer>(9, IA6, IntegerEqualityComparer), 'I3');
  CheckEquals(0, TArrayUtils.OccurrencesOf<Integer>(4, IA1, IntegerEqualityComparer), 'I4');
  CheckEquals(1, TArrayUtils.OccurrencesOf<Integer>(7, IA1, IntegerEqualityComparer), 'I5');

  CheckEquals(1, TArrayUtils.OccurrencesOf<string>('two', SA2, StringEqualityComparer), 'S1');
  CheckEquals(1, TArrayUtils.OccurrencesOf<string>('eight', SA2, StringEqualityComparer), 'S2');
  CheckEquals(0, TArrayUtils.OccurrencesOf<string>('nine', SA2, StringEqualityComparer), 'S3');
  CheckEquals(5, TArrayUtils.OccurrencesOf<string>('one', SA6, StringEqualityComparer), 'S4');
  CheckEquals(0, TArrayUtils.OccurrencesOf<string>('nine', SA0, StringEqualityComparer), 'S5');
  CheckEquals(0, TArrayUtils.OccurrencesOf<string>('four', SA2DupIgnoreCase, StringEqualityComparer), 'S6');

  CheckEquals(1, TArrayUtils.OccurrencesOf<string>('two', SA2, TextEqualityComparer), 'T1');
  CheckEquals(1, TArrayUtils.OccurrencesOf<string>('EIGHT', SA2, TextEqualityComparer), 'T2');
  CheckEquals(0, TArrayUtils.OccurrencesOf<string>('nine', SA2, TextEqualityComparer), 'T3');
  CheckEquals(5, TArrayUtils.OccurrencesOf<string>('one', SA6, TextEqualityComparer), 'T4');
  CheckEquals(0, TArrayUtils.OccurrencesOf<string>('nine', SA0, TextEqualityComparer), 'T5');
  CheckEquals(1, TArrayUtils.OccurrencesOf<string>('four', SA2DupIgnoreCase, TextEqualityComparer), 'T6');

  CheckEquals(1, TArrayUtils.OccurrencesOf<TPoint>(Pp1p3, PA4, PointEqualityComparer), 'P1');
  CheckEquals(0, TArrayUtils.OccurrencesOf<TPoint>(Pp12m12, PA4, PointEqualityComparer), 'P2');
  CheckEquals(2, TArrayUtils.OccurrencesOf<TPoint>(Pp1p3, PA2, PointEqualityComparer), 'P3');

  CheckEquals(3, TArrayUtils.OccurrencesOf<TTestObj>(O2, OATwoPeeks, TestObjEqualityComparer), 'O1');
  CheckEquals(1, TArrayUtils.OccurrencesOf<TTestObj>(O2, OA2Dup, TestObjEqualityComparer), 'O2');
  CheckEquals(0, TArrayUtils.OccurrencesOf<TTestObj>(O1, OA3, TestObjEqualityComparer), 'O3');
end;

procedure TestTArrayUtils.TestOccurrencesOf_NilComparer_Overload;
begin
  CheckEquals(1, TArrayUtils.OccurrencesOf<Integer>(4, IA2), 'I1');
  CheckEquals(0, TArrayUtils.OccurrencesOf<Integer>(5, IA2), 'I2');
  CheckEquals(6, TArrayUtils.OccurrencesOf<Integer>(9, IA6), 'I3');
  CheckEquals(0, TArrayUtils.OccurrencesOf<Integer>(4, IA1), 'I4');
  CheckEquals(1, TArrayUtils.OccurrencesOf<Integer>(7, IA1), 'I5');

  CheckEquals(1, TArrayUtils.OccurrencesOf<string>('two', SA2), 'S1');
  CheckEquals(1, TArrayUtils.OccurrencesOf<string>('eight', SA2), 'S2');
  CheckEquals(0, TArrayUtils.OccurrencesOf<string>('nine', SA2), 'S3');
  CheckEquals(5, TArrayUtils.OccurrencesOf<string>('one', SA6), 'S4');
  CheckEquals(0, TArrayUtils.OccurrencesOf<string>('nine', SA0), 'S5');
  CheckEquals(0, TArrayUtils.OccurrencesOf<string>('four', SA2DupIgnoreCase), 'S6');

  CheckEquals(1, TArrayUtils.OccurrencesOf<TPoint>(Pp1p3, PA4), 'P1');
  CheckEquals(0, TArrayUtils.OccurrencesOf<TPoint>(Pp12m12, PA4), 'P2');
  CheckEquals(2, TArrayUtils.OccurrencesOf<TPoint>(Pp1p3, PA2), 'P3');

  CheckEquals(3, TArrayUtils.OccurrencesOf<TTestObj>(O2, OATwoPeeks), 'O1');
  CheckEquals(0, TArrayUtils.OccurrencesOf<TTestObj>(O2, OA2Dup), 'O2');
  CheckEquals(0, TArrayUtils.OccurrencesOf<TTestObj>(O1, OA3), 'O3');
end;

procedure TestTArrayUtils.TestPick;
var
  IGot, IExpected: TArray<Integer>;
  SGot, SExpected: TArray<string>;
  PGot, PExpected: TArray<TPoint>;
  OGot, OExpected: TArray<TTestObj>;
  PickIdxs: TArray<Integer>;
begin
  PickIdxs := TArray<Integer>.Create(1, 3);
  IGot := TArrayUtils.Pick<Integer>(IA2, PickIdxs);
  IExpected := TArray<Integer>.Create(4, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I1a');

  PickIdxs := TArray<Integer>.Create(3, 1, 3, 3, 1);
  IGot := TArrayUtils.Pick<Integer>(IA2, PickIdxs);
  IExpected := TArray<Integer>.Create(8, 4, 8, 8, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I1b');

  PickIdxs := TArray<Integer>.Create(-1, 1, 0, 2, 1, 4);
  IGot := TArrayUtils.Pick<Integer>(IA2, PickIdxs);
  IExpected := TArray<Integer>.Create(4, 2, 6, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I2');

  PickIdxs := TArray<Integer>.Create(-1, 4);
  IGot := TArrayUtils.Pick<Integer>(IA2, PickIdxs);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I3');

  PickIdxs := TArray<Integer>.Create();
  IGot := TArrayUtils.Pick<Integer>(IA2, PickIdxs);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I4');

  PickIdxs := TArray<Integer>.Create(3, 2, 1, 0);
  IGot := TArrayUtils.Pick<Integer>(IA2, PickIdxs);
  IExpected := TArray<Integer>.Create(8, 6, 4, 2);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I5');

  PickIdxs := TArray<Integer>.Create(0, 3);
  IGot := TArrayUtils.Pick<Integer>(IA0, PickIdxs);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I6');

  PickIdxs := TArray<Integer>.Create();
  IGot := TArrayUtils.Pick<Integer>(IA0, PickIdxs);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I7');

  PickIdxs := TArray<Integer>.Create(1, 3, 5);
  SGot := TArrayUtils.Pick<string>(SA7, PickIdxs);
  SExpected := TArray<string>.Create('three', 'three', 'one');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot), 'S');

  PickIdxs := TArray<Integer>.Create(2, 1, 2);
  PGot := TArrayUtils.Pick<TPoint>(PA3, PickIdxs);
  PExpected := TArray<TPoint>.Create(Pm8m9, Pm1p5, Pm8m9);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot), 'P');

  PickIdxs := TArray<Integer>.Create(2);
  OGot := TArrayUtils.Pick<TTestObj>(OA3, PickIdxs);
  OExpected := TArray<TTestObj>.Create(O3);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OGot), 'O');
end;

procedure TestTArrayUtils.TestPop;
var
  IA, IExpected: TArray<Integer>;   I: Integer;
  SA, SExpected: TArray<string>;    S: string;
  PA, PExpected: TArray<TPoint>;    P: TPoint;
  OA, OExpected: TArray<TTestObj>;  O: TTestObj;
begin
  IA := Copy(IA2);

  I := TArrayUtils.Pop<Integer>(IA);
  IExpected := TArray<Integer>.Create(2, 4, 6);
  CheckEquals(8, I, 'I1 popped');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1 remaining');

  I := TArrayUtils.Pop<Integer>(IA);
  IExpected := TArray<Integer>.Create(2, 4);
  CheckEquals(6, I, 'I2 popped');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2 remaining');

  I := TArrayUtils.Pop<Integer>(IA);
  IExpected := TArray<Integer>.Create(2);
  CheckEquals(4, I, 'I3 popped');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3 remaining');

  I := TArrayUtils.Pop<Integer>(IA);
  IExpected := TArray<Integer>.Create();
  CheckEquals(2, I, 'I4 popped');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I4 remaining');

  SA := Copy(SA1five);

  SExpected := TArray<string>.Create();
  S := TArrayUtils.Pop<string>(SA);
  CheckEquals('five', S, 'S1 popped');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S1 remaining');

  SA := Copy(SA5);

  SExpected := TArray<string>.Create('one', 'two', 'one');
  S := TArrayUtils.Pop<string>(SA);
  CheckEquals('two', S, 'S2 popped');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S2 remaining');

  PA := Copy(PA4);

  PExpected := TArray<TPoint>.Create(Pp1p3, Pm8m9);
  P := TArrayUtils.Pop<TPoint>(PA);
  CheckTrue(PointEqualsFn(Pm1p5, P), 'P popped');
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA), 'P remaining');

  OA := Copy(OA3);

  OExpected := TArray<TTestObj>.Create(O4, O5, O3);
  O := TArrayUtils.Pop<TTestObj>(OA);
  CheckTrue(TestObjEqualsFn(O2, O), 'O popped');
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA), 'O remaining');

  CheckException(Pop_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestPopAndFree;
var
  StartInstanceCount: Integer;
  OA, OExpected: TArray<TTestObj>;
begin
  StartInstanceCount := TTestObj.InstanceCount;

  // Pop array with 5 elements
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O1:instances-begin');
    TArrayUtils.PopAndFree<TTestObj>(OA);
    OExpected := TArray<TTestObj>.Create(O1, O2, O3, O4);
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O1:after-pop');
    CheckEquals(4, Length(OA), 'O1:after-pop-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O1:instances-after-pop');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O1:instances-end');

  // Pop array with 1 element
  OA := TArrayUtils.Copy<TTestObj>(OA1, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O2:instances-begin');
    TArrayUtils.PopAndFree<TTestObj>(OA);
    OExpected := TArray<TTestObj>.Create();
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O2:after-delete');
    CheckEquals(0, Length(OA), 'O2:after-delete-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O2:instances-after-delete');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O2:instances-end');

  CheckException(PopAndFree_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestPopAndRelease;
var
  R1, R2, R3: TTestResource;
  RA, RExpected: TArray<TTestResource>;
  Freer: TArrayUtils.TCallback<TTestResource>;
begin
  Freer := procedure (const ARes: TTestResource)
    begin
      ARes.Release;
    end;
  R1 := TTestResource.Create('A', 1);
  R2 := TTestResource.Create('B', 2);
  R3 := TTestResource.Create('C', 3);
  RA := TArray<TTestResource>.Create(R1, R2, R3);
  CheckEquals(3, TTestResource.InstanceCount, 'R: check 3 instances');

  TArrayUtils.PopAndRelease<TTestResource>(RA, Freer);
  RExpected := TArray<TTestResource>.Create(R1, R2);
  CheckTrue(TArrayUtils.Equal<TTestResource>(RExpected, RA), 'R: check array post deletion');
  CheckEquals(2, TTestResource.InstanceCount, 'R: check 2 instances after deletion');

  ReleaseTestResources(RA);
  CheckEquals(0, TTestResource.InstanceCount, 'R: all instance released');

  CheckException(PopAndRelease_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestPush;
var
  IA, IExpected: TArray<Integer>;
  SA, SExpected: TArray<string>;
  PA, PExpected: TArray<TPoint>;
  OA, OExpected: TArray<TTestObj>;
begin
  IA := Copy(IA0);

  TArrayUtils.Push<Integer>(IA, 42);
  IExpected := TArray<Integer>.Create(42);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1');

  IA := Copy(IA1);

  TArrayUtils.Push<Integer>(IA, 9);
  IExpected := TArray<Integer>.Create(7, 9);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2a');

  TArrayUtils.Push<Integer>(IA, 11);
  IExpected := TArray<Integer>.Create(7, 9, 11);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2b');

  IA := Copy(IA4);

  TArrayUtils.Push<Integer>(IA, 11);
  IExpected := TArray<Integer>.Create(1, 3, 5, 7, 9, 11);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3a');

  TArrayUtils.Push<Integer>(IA, 13);
  IExpected := TArray<Integer>.Create(1, 3, 5, 7, 9, 11, 13);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3b');

  SA := Copy(SA5);

  TArrayUtils.Push<string>(SA, 'three');
  SExpected := TArray<string>.Create('one', 'two', 'one', 'two', 'three');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'Sa');

  TArrayUtils.Push<string>(SA, 'four');
  SExpected := TArray<string>.Create('one', 'two', 'one', 'two', 'three', 'four');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'Sb');

  PA := Copy(PA0);

  TArrayUtils.Push<TPoint>(PA, Pp1p3);
  PExpected := TArray<TPoint>.Create(Pp1p3);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA), 'Pa');

  TArrayUtils.Push<TPoint>(PA, Pm8m9);
  PExpected := TArray<TPoint>.Create(Pp1p3, Pm8m9);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA), 'Pb');

  OA := Copy(OA1);

  TArrayUtils.Push<TTestObj>(OA, O5);
  OExpected := TArray<TTestObj>.Create(O1, O5);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA), 'O');
end;

procedure TestTArrayUtils.TestReduce_InitValueAndExtendedCallback_OneType_Overload;
var
  SumDistancesReducer: TArrayUtils.TReducerEx<Integer>;
  DistanceSum: Integer;
begin

  // Adds the absolute distances between adjacent elements of an integer array
  SumDistancesReducer := function (const AAccumulator, ACurrent: Integer;
    const AIndex: Integer; const A: array of Integer): Integer
    var
      Distance: Integer;
    begin
      Result := AAccumulator;
      if AIndex = 0 then
        Exit;
      Distance := Abs(A[AIndex] - A[AIndex - 1]);
      Result := Result + Distance;
    end;

  DistanceSum := TArrayUtils.Reduce<Integer>(IA1, SumDistancesReducer, 0);
  CheckEquals(0, DistanceSum, 'SumDistances-1');

  DistanceSum := TArrayUtils.Reduce<Integer>(IA2, SumDistancesReducer, 0);
  CheckEquals(6, DistanceSum, 'SumDistances-2');

  DistanceSum := TArrayUtils.Reduce<Integer>(IA3, SumDistancesReducer, 0);
  CheckEquals(8, DistanceSum, 'SumDistances-3');

  DistanceSum := TArrayUtils.Reduce<Integer>(IA6, SumDistancesReducer, 0);
  CheckEquals(2, DistanceSum, 'SumDistances-4');

  DistanceSum := TArrayUtils.Reduce<Integer>(IA5, SumDistancesReducer, 0);
  CheckEquals(8, DistanceSum, 'SumDistances-5');

  DistanceSum := TArrayUtils.Reduce<Integer>(IA0, SumDistancesReducer, 0);
  CheckEquals(0, DistanceSum, 'SumDistances-6');
end;

procedure TestTArrayUtils.TestReduce_InitValueAndExtendedCallback_TwoTypes_Overload;
var
  CountAdjacentNumbersReducer: TArrayUtils.TReducerEx<Integer,Cardinal>;
  AdjacentCount: Cardinal;
  AverageReducer: TArrayUtils.TReducerEx<Integer,Extended>;
  Average: Extended;
  LongestWordsReducer: TArrayUtils.TReducerEx<string,TArray<string>>;
  LongestWords: TArray<string>;
  ExpectedLongestWords: TArray<string>;
  InitWords: TArray<string>;
const
  Delta = 0.000001;
begin
  // Count all elements separated by a distance of 1 from their preceding elements
  CountAdjacentNumbersReducer := function (const AAccumulator: Cardinal; const ACurrent: Integer;
    const AIndex: Integer; const A: array of Integer): Cardinal
    begin
      Result := AAccumulator;
      if AIndex = 0 then
        Exit;
      if Abs(A[AIndex] - A[AIndex - 1]) = 1then
        Inc(Result);
    end;

  AdjacentCount := TArrayUtils.Reduce<Integer,Cardinal>(IA0, CountAdjacentNumbersReducer, 0);
  CheckEquals(0, AdjacentCount, 'CountAdjacentNumbers-1');

  AdjacentCount := TArrayUtils.Reduce<Integer,Cardinal>(IA1, CountAdjacentNumbersReducer, 0);
  CheckEquals(0, AdjacentCount, 'CountAdjacentNumbers-2');

  AdjacentCount := TArrayUtils.Reduce<Integer,Cardinal>(IA2, CountAdjacentNumbersReducer, 0);
  CheckEquals(0, AdjacentCount, 'CountAdjacentNumbers-3');

  AdjacentCount := TArrayUtils.Reduce<Integer,Cardinal>(IA3, CountAdjacentNumbersReducer, 0);
  CheckEquals(1, AdjacentCount, 'CountAdjacentNumbers-4');

  AdjacentCount := TArrayUtils.Reduce<Integer,Cardinal>(IA5, CountAdjacentNumbersReducer, 0);
  CheckEquals(8, AdjacentCount, 'CountAdjacentNumbers-5');

  AdjacentCount := TArrayUtils.Reduce<Integer,Cardinal>(IA6, CountAdjacentNumbersReducer, 0);
  CheckEquals(2, AdjacentCount, 'CountAdjacentNumbers-6');

  AverageReducer := function (const AAccumulator: Extended; const ACurrent: Integer;
    const AIndex: Integer; const A: array of Integer): Extended
    begin
      // Don't call with empty array
      Result := AAccumulator + ACurrent / Length(A);
    end;

  Average := TArrayUtils.Reduce<Integer,Extended>(IA1, AverageReducer, 0.0);
  CheckEquals(7.0, Average, Delta, 'Average-1');

  Average := TArrayUtils.Reduce<Integer,Extended>(IA2, AverageReducer, 0.0);
  CheckEquals(5.0, Average, Delta, 'Average-2');

  Average := TArrayUtils.Reduce<Integer,Extended>(IA3, AverageReducer, 0.0);
  CheckEquals(4.6, Average, Delta, 'Average-3');

  Average := TArrayUtils.Reduce<Integer,Extended>(IA6, AverageReducer, 0.0);
  CheckEquals(8.85714285714286, Average, Delta, 'Average-4');

  LongestWordsReducer := function (const AAccumulator: TArray<string>; const ACurrent: string;
    const AIndex: Integer; const A: array of string): TArray<string>
    var
      Word: string;
      LongestWordLen: Integer;
      ThisWord: string;
    begin
      Result := AAccumulator;
      LongestWordLen := 0;
      for Word in A do
        if Length(Word) > LongestWordLen then
          LongestWordLen := Length(Word);
      ThisWord := A[AIndex];
      if Length(ThisWord) = LongestWordLen then
      begin
        if TArrayUtils.IndexOf<string>(ThisWord, Result, StrEqualsTextFn) = -1 then
        begin
          SetLength(Result, Length(Result) + 1);
          Result[Pred(Length(Result))] := ThisWord;
        end;
      end;
    end;

  InitWords := TArray<string>.Create();

  LongestWords := TArrayUtils.Reduce<string,TArray<string>>(SA2, LongestWordsReducer, InitWords);
  ExpectedLongestWords := TArray<string>.Create('eight');
  CheckTrue(TArrayUtils.Equal<string>(ExpectedLongestWords, LongestWords, StrEqualsStrFn), 'LongestWords-1');

  LongestWords := TArrayUtils.Reduce<string,TArray<string>>(SA4, LongestWordsReducer, InitWords);
  ExpectedLongestWords := TArray<string>.Create('three', 'seven');
  CheckTrue(TArrayUtils.Equal<string>(ExpectedLongestWords, LongestWords, StrEqualsStrFn), 'LongestWords-2');

  LongestWords := TArrayUtils.Reduce<string,TArray<string>>(SA0, LongestWordsReducer, InitWords);
  ExpectedLongestWords := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(ExpectedLongestWords, LongestWords, StrEqualsStrFn), 'LongestWords-3');
end;

procedure TestTArrayUtils.TestReduce_InitValueAndSimpleCallback_OneType_Overload;
var
  Sum: Integer;
  ConcatStr: string;
  SumReducer: TArrayUtils.TReducer<Integer>;
  ConcatReducer: TArrayUtils.TReducer<string>;
begin
  SumReducer := function (const AAccumulator, ACurrent: Integer): Integer
    begin
      Result := ACurrent + AAccumulator;
    end;

  Sum := TArrayUtils.Reduce<Integer>(IA2, SumReducer, 0);
  CheckEquals(20, Sum, 'Sum-1');

  Sum := TArrayUtils.Reduce<Integer>(IA3, SumReducer, Sum);
  CheckEquals(20 + 23, Sum, 'Sum-2');

  Sum := TArrayUtils.Reduce<Integer>(IA0, SumReducer, Sum);
  CheckEquals(20 + 23 + 0, Sum, 'Sum-3');

  ConcatReducer := function (const AAccumulator, ACurrent: string): string
    begin
      Result := AAccumulator + ACurrent;
    end;

  ConcatStr := TArrayUtils.Reduce<string>(SA1five, ConcatReducer, '->');
  CheckEquals('->five', ConcatStr, 'ConcatStr-1');

  ConcatStr := TArrayUtils.Reduce<string>(SA2, ConcatReducer, '');
  CheckEquals('twofoursixeight', ConcatStr, 'ConcatStr-2');
end;

procedure TestTArrayUtils.TestReduce_InitValueAndSimpleCallback_TwoTypes_Overload;
var
  Avg: Extended;
  ExpectedAvg: Extended;
  CountOnesReducer: TArrayUtils.TReducer<string,Integer>;
  OnesCount: Integer;
  GreatestDistancesReducer: TArrayUtils.TReducer<TPoint,Extended>;
  TestObjReducer: TArrayUtils.TReducer<TTestObj,string>;
  Distance, ExpectedDistance: Extended;
  ExpectedObjToStr, ObjToStr: string;

  function Average(A: array of Integer): Extended;
  var
    AvgReducer: TArrayUtils.TReducer<Integer,Extended>;
    Arr: TArray<Integer>;
  begin
    // can't capture A in AvgReducer in some Delphis, so copy it
    Arr := TArrayUtils.Copy<Integer>(A);
    AvgReducer := function (const AAccumulator: Extended; const ACurrent: Integer): Extended
      begin
        Result := AAccumulator + ACurrent / Length(Arr);
      end;
    Result := TArrayUtils.Reduce<Integer,Extended>(Arr, AvgReducer, 0.0);
  end;

const
  Delta = 0.0000001;
begin
  Avg := Average(IA2);
  ExpectedAvg := 5.0;
  CheckEquals(ExpectedAvg, Avg, Delta, 'Avg-1');

  Avg := Average(IA1);
  ExpectedAvg := 7.0;
  CheckEquals(ExpectedAvg, Avg, Delta, 'Avg-2');

  Avg := Average(IA6);
  ExpectedAvg := 8.85714285714286;
  CheckEquals(ExpectedAvg, Avg, Delta, 'Avg-3');

  CountOnesReducer := function (const AAccumulator: Integer; const ACurrent: string): Integer
    begin
      Result := AAccumulator;
      if ACurrent = 'one' then
        Inc(Result);
    end;

  OnesCount := TArrayUtils.Reduce<string,Integer>(SA0, CountOnesReducer, 0);
  CheckEquals(0, OnesCount, 'CountOnes-1');

  OnesCount := TArrayUtils.Reduce<string,Integer>(SA4, CountOnesReducer, 0);
  CheckEquals(1, OnesCount, 'CountOnes-2');

  OnesCount := TArrayUtils.Reduce<string,Integer>(SA6, CountOnesReducer, 0);
  CheckEquals(5, OnesCount, 'CountOnes-3');

  GreatestDistancesReducer := function (const AAccumulator: Extended; const ACurrent: TPoint): Extended
    var
      Distance: Extended;
    begin
      Distance := DistFromOrigin(ACurrent);
      if Distance > AAccumulator then
        Result := Distance
      else
        Result := AAccumulator;
    end;

  Distance := TArrayUtils.Reduce<TPoint,Extended>(PA3, GreatestDistancesReducer, 0.0);
  ExpectedDistance := 12.0415945787; // point (-8,-9)
  CheckEquals(ExpectedDistance, Distance, Delta, 'GreatestDistance-1');

  Distance := TArrayUtils.Reduce<TPoint,Extended>(PA1, GreatestDistancesReducer, 0.0);
  ExpectedDistance := 3.1622776601683; // point (1, 3)
  CheckEquals(ExpectedDistance, Distance, Delta, 'GreatestDistance-2');

  TestObjReducer := function (const AAccumulator: string; const ACurrent: TTestObj): string
    begin
      Result := AAccumulator + ACurrent.A;
    end;
  ObjToStr := TArrayUtils.Reduce<TTestObj,string>(OA3, TestObjReducer, '');
  ExpectedObjToStr := '@dcb';
  CheckEquals(ExpectedObjToStr, ObjToStr, 'TestObj');
end;

procedure TestTArrayUtils.TestReduce_SimpleCallback_Overload;
var
  Sum, ExpectedSum: Integer;
  LongestStr, ExpectedLongestStr: string;
  FurthestPoint, ExpectedFurthestPoint: TPoint;
  ChosenObj, ExpectedChosenObj: TTestObj;
  SumReducer: TArrayUtils.TReducer<Integer>;
  LongestStringReducer: TArrayUtils.TReducer<string>;
  FurthestPointReducer: TArrayUtils.TReducer<TPoint>;
  TestObjReducer: TArrayUtils.TReducer<TTestObj>;
begin
  SumReducer := function (const AAccumulator, ACurrent: Integer): Integer
    begin
      Result := ACurrent + AAccumulator;
    end;
  LongestStringReducer := function (const AAccumulator, ACurrent: string): string
    begin
      if Length(ACurrent) > Length(AAccumulator) then
        Result := ACurrent
      else
        Result := AAccumulator;
    end;
  FurthestPointReducer := function (const AAccumulator, ACurrent: TPoint): TPoint
    var
      ValueDistance, AccumDistance: Extended;
    begin
      ValueDistance := DistFromOrigin(ACurrent);
      AccumDistance := DistFromOrigin(AAccumulator);
      if ValueDistance > AccumDistance then
        Result := ACurrent
      else
        Result := AAccumulator;
    end;
  TestObjReducer := function (const AAccumulator, ACurrent: TTestObj): TTestObj
    begin
      if ACurrent.B.Count > AAccumulator.B.Count then
        Result := ACurrent
      else
        Result := AAccumulator;
    end;

  ExpectedSum := 7;
  Sum := TArrayUtils.Reduce<Integer>(IA1, SumReducer);
  CheckEquals(ExpectedSum, Sum, 'Sum-1');

  ExpectedSum := 16;
  Sum := TArrayUtils.Reduce<Integer>(IA5, SumReducer);
  CheckEquals(ExpectedSum, Sum, 'Sum-2');

  ExpectedSum := 20;
  Sum := TArrayUtils.Reduce<Integer>(IA2, SumReducer);
  CheckEquals(ExpectedSum, Sum, 'Sum-3');

  ExpectedLongestStr := 'eight';
  LongestStr := TArrayUtils.Reduce<string>(SA2, LongestStringReducer);
  CheckEquals(ExpectedLongestStr, LongestStr, 'LongestString-1');

  ExpectedLongestStr := 'one';
  LongestStr := TArrayUtils.Reduce<string>(SA5, LongestStringReducer);
  CheckEquals(ExpectedLongestStr, LongestStr, 'LongestString-2');

  ExpectedFurthestPoint := Pp1p3;
  FurthestPoint := TArrayUtils.Reduce<TPoint>(PA1, FurthestPointReducer);
  CheckTrue(PointEqualsFn(ExpectedFurthestPoint, FurthestPoint), 'FurthestPoint-1');

  ExpectedFurthestPoint := Pm8m9;
  FurthestPoint := TArrayUtils.Reduce<TPoint>(PA3, FurthestPointReducer);
  CheckTrue(PointEqualsFn(ExpectedFurthestPoint, FurthestPoint), 'FurthestPoint-2');

  ExpectedChosenObj := O1;
  ChosenObj := TArrayUtils.Reduce<TTestObj>(OA2Rev, TestObjReducer);
  CheckTrue(TestObjEqualsFn(ExpectedChosenObj, ChosenObj), 'TestObj-1');

  ExpectedChosenObj := O3;
  ChosenObj := TArrayUtils.Reduce<TTestObj>(OA3, TestObjReducer);
  CheckTrue(TestObjEqualsFn(ExpectedChosenObj, ChosenObj), 'TestObj-2');

  CheckException(Reduce_SimpleCallback_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestReverse;
var
  IA: TArray<Integer>;
  SA: TArray<string>;
  OA: TArray<TTestObj>;
begin
  IA := Copy(IA2);
  TArrayUtils.Reverse<Integer>(IA);
  CheckTrue(TArrayUtils.Equal<Integer>(IA2Rev, IA, IntEqualsFn), 'I1');

  IA := Copy(IA0);
  TArrayUtils.Reverse<Integer>(IA);
  CheckTrue(TArrayUtils.Equal<Integer>(IA0, IA, IntEqualsFn), 'I2');

  IA := Copy(IA3);
  TArrayUtils.Reverse<Integer>(IA);
  CheckTrue(TArrayUtils.Equal<Integer>(IA3Rev, IA, IntEqualsFn), 'I3');

  IA := Copy(IA6);
  TArrayUtils.Reverse<Integer>(IA);
  CheckTrue(TArrayUtils.Equal<Integer>(IA6, IA, IntEqualsFn), 'I4');

  SA := Copy(SA2);
  TArrayUtils.Reverse<string>(SA);
  CheckTrue(TArrayUtils.Equal<string>(SA2Rev, SA, StrEqualsStrFn), 'S1');

  SA := Copy(SA0);
  TArrayUtils.Reverse<string>(SA0);
  CheckTrue(TArrayUtils.Equal<string>(SA0, SA, StrEqualsStrFn), 'S2');

  SA := Copy(SA1five);
  TArrayUtils.Reverse<string>(SA);
  CheckTrue(TArrayUtils.Equal<string>(SA1five, SA, StrEqualsStrFn), 'S3');

  SA := Copy(SA2DupIgnoreCase);
  TArrayUtils.Reverse<string>(SA);
  CheckTrue(TArrayUtils.Equal<string>(SA2Rev, SA, StrEqualsTextFn), 'T');

  OA := Copy(OA2);
  TArrayUtils.Reverse<TTestObj>(OA);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OA2Rev, OA, TestObjEqualsFn), 'O');
end;

procedure TestTArrayUtils.TestShift;
var
  IA, IExpected: TArray<Integer>;   I: Integer;
  SA, SExpected: TArray<string>;    S: string;
  PA, PExpected: TArray<TPoint>;    P: TPoint;
  OA, OExpected: TArray<TTestObj>;  O: TTestObj;
begin
  IA := Copy(IA2);

  I := TArrayUtils.Shift<Integer>(IA);
  IExpected := TArray<Integer>.Create(4, 6, 8);
  CheckEquals(2, I, 'I1 shifted');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1 remaining');

  I := TArrayUtils.Shift<Integer>(IA);
  IExpected := TArray<Integer>.Create(6, 8);
  CheckEquals(4, I, 'I2 shifted');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2 remaining');

  I := TArrayUtils.Shift<Integer>(IA);
  IExpected := TArray<Integer>.Create(8);
  CheckEquals(6, I, 'I3 shifted');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3 remaining');

  I := TArrayUtils.Shift<Integer>(IA);
  IExpected := TArray<Integer>.Create();
  CheckEquals(8, I, 'I4 shifted');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I4 remaining');

  SA := Copy(SA1five);

  SExpected := TArray<string>.Create();
  S := TArrayUtils.Shift<string>(SA);
  CheckEquals('five', S, 'S1 shifted');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S1 remaining');

  SA := Copy(SA5);

  SExpected := TArray<string>.Create('two', 'one', 'two');
  S := TArrayUtils.Shift<string>(SA);
  CheckEquals('one', S, 'S2 shifted');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S2 remaining');

  PA := Copy(PA4);

  PExpected := TArray<TPoint>.Create(Pm8m9, Pm1p5);
  P := TArrayUtils.Shift<TPoint>(PA);
  CheckTrue(PointEqualsFn(Pp1p3, P), 'P shifted');
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA), 'P remaining');

  OA := Copy(OA3);

  OExpected := TArray<TTestObj>.Create(O5, O3, O2);
  O := TArrayUtils.Shift<TTestObj>(OA);
  CheckTrue(TestObjEqualsFn(O4, O), 'O shifted');
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA), 'O remaining');

  CheckException(Shift_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestShiftAndFree;
var
  StartInstanceCount: Integer;
  OA, OExpected: TArray<TTestObj>;
begin
  StartInstanceCount := TTestObj.InstanceCount;

  // Shift array with 5 elements
  OA := TArrayUtils.Copy<TTestObj>(OA2, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O1:instances-begin');
    TArrayUtils.ShiftAndFree<TTestObj>(OA);
    OExpected := TArray<TTestObj>.Create(O2, O3, O4, O5);
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O1:after-shift');
    CheckEquals(4, Length(OA), 'O1:after-shift-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O1:instances-after-shift');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O1:instances-end');

  // Shift array with 1 element
  OA := TArrayUtils.Copy<TTestObj>(OA1, ObjCloner);
  try
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O2:instances-begin');
    TArrayUtils.ShiftAndFree<TTestObj>(OA);
    OExpected := TArray<TTestObj>.Create();
    CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O2:after-shift');
    CheckEquals(0, Length(OA), 'O2:after-shift-array-length');
    CheckEquals(StartInstanceCount + Length(OA), TTestObj.InstanceCount, 'O2:instances-after-shift');
  finally
    FreeTestObjs(OA);
  end;
  CheckEquals(StartInstanceCount, TTestObj.InstanceCount, 'O2:instances-end');

  CheckException(ShiftAndFree_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestShiftAndRelease;
var
  R1, R2, R3: TTestResource;
  RA, RExpected: TArray<TTestResource>;
  Freer: TArrayUtils.TCallback<TTestResource>;
begin
  Freer := procedure (const ARes: TTestResource)
    begin
      ARes.Release;
    end;
  R1 := TTestResource.Create('A', 1);
  R2 := TTestResource.Create('B', 2);
  R3 := TTestResource.Create('C', 3);
  RA := TArray<TTestResource>.Create(R1, R2, R3);
  CheckEquals(3, TTestResource.InstanceCount, 'R: check 3 instances');

  TArrayUtils.ShiftAndRelease<TTestResource>(RA, Freer);
  RExpected := TArray<TTestResource>.Create(R2, R3);
  CheckTrue(TArrayUtils.Equal<TTestResource>(RExpected, RA), 'R: check array post deletion');
  CheckEquals(2, TTestResource.InstanceCount, 'R: check 2 instances after deletion');

  ReleaseTestResources(RA);
  CheckEquals(0, TTestResource.InstanceCount, 'R: all instance released');

  CheckException(ShiftAndRelease_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestSlice_DoubleIdx_Overload;
var
  IGot, IExpected: TArray<Integer>;
  SGot, SExpected: TArray<string>;
  PGot, PExpected: TArray<TPoint>;
  OGot, OExpected: TArray<TTestObj>;
begin
  IGot := TArrayUtils.Slice<Integer>(IA5, 3, 7);
  IExpected := TArray<Integer>.Create(3, 4, 3, 2, 1);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I1');

  IGot := TArrayUtils.Slice<Integer>(IA5, 0, 3);
  IExpected := TArray<Integer>.Create(0, 1, 2, 3);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I2');

  IGot := TArrayUtils.Slice<Integer>(IA5, 7, 8);
  IExpected := TArray<Integer>.Create(1, 0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I3');

  IGot := TArrayUtils.Slice<Integer>(IA5, 4, 4);
  IExpected := TArray<Integer>.Create(4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I4');

  IGot := TArrayUtils.Slice<Integer>(IA5, -1, 4);
  IExpected := TArray<Integer>.Create(0, 1, 2, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I5');

  IGot := TArrayUtils.Slice<Integer>(IA2, 1, Length(IA2) + 3);
  IExpected := TArray<Integer>.Create(4, 6, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I6a');

  IGot := TArrayUtils.Slice<Integer>(IA2, 1, Pred(Length(IA2)));
  IExpected := TArray<Integer>.Create(4, 6, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I6b');

  IGot := TArrayUtils.Slice<Integer>(IA5, 5, 4);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I7');

  IGot := TArrayUtils.Slice<Integer>(IA5, 20, -12);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I8');

  IGot := TArrayUtils.Slice<Integer>(IA5, -12, 4);
  IExpected := TArray<Integer>.Create(0, 1, 2, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I9');

  SGot := TArrayUtils.Slice<string>(SA6, 2, 4);
  SExpected := TArray<string>.Create('two', 'one', 'one');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot, StrEqualsStrFn), 'S');

  // single element array
  PGot := TArrayUtils.Slice<TPoint>(PA1, 0, 0);
  PExpected := PA1;
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot, PointEqualsFn), 'P');

  // empty array
  OGot := TArrayUtils.Slice<TTestObj>(OA0, 0, 0);
  OExpected := TArray<TTestObj>.Create();
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OGot, TestObjEqualsFn), 'O');
end;

procedure TestTArrayUtils.TestSlice_SingleIdx_Overload;
var
  IGot, IExpected: TArray<Integer>;
  SGot, SExpected: TArray<string>;
  PGot, PExpected: TArray<TPoint>;
  OGot, OExpected: TArray<TTestObj>;
begin
  IGot := TArrayUtils.Slice<Integer>(IA5, 3);
  IExpected := TArray<Integer>.Create(3, 4, 3, 2, 1, 0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I1');

  IGot := TArrayUtils.Slice<Integer>(IA5, Pred(Length(IA5)));
  IExpected := TArray<Integer>.Create(0);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I2');

  IGot := TArrayUtils.Slice<Integer>(IA5, Length(IA5));
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I3a');

  IGot := TArrayUtils.Slice<Integer>(IA5, Length(IA5) + 6);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I3b');

  IGot := TArrayUtils.Slice<Integer>(IA5, 0);
  IExpected := IA5;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I4a');

  IGot := TArrayUtils.Slice<Integer>(IA5, -2);
  IExpected := IA5;
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IGot), 'I4b');

  // single element array
  SGot := TArrayUtils.Slice<string>(SA1two, 0);
  SExpected := SA1two;
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot, StrEqualsStrFn), 'S1');

  SGot := TArrayUtils.Slice<string>(SA1two, 1);
  SExpected := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SGot, StrEqualsStrFn), 'S2');

  // empty array
  PGot := TArrayUtils.Slice<TPoint>(PA0, 0);
  PExpected := TArray<TPoint>.Create();
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PGot, PointEqualsFn), 'P');

  OGot := TArrayUtils.Slice<TTestObj>(OA2, 2);
  OExpected := TArray<TTestObj>.Create(O3, O4, O5);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OGot, TestObjEqualsFn), 'O');
end;

procedure TestTArrayUtils.TestSome_ExtendedCallback_Overload;
var
  ICallback: TArrayUtils.TConstraintEx<Integer>;
  SCallback: TArrayUtils.TConstraintEx<string>;
  PCallback: TArrayUtils.TConstraintEx<TPoint>;
begin
  ICallback := function (const AElem: Integer; const AIndex: Integer;
    const A: array of Integer): Boolean
    var
      Distance: Integer;
    begin
      // True iff distance betwent element and prior element >=2
      // Assume that single element arrays don't meet the criteria
      Assert(A[AIndex] = AElem);
      if AIndex = 0 then
        Exit(False);
      Distance := Abs(A[AIndex] - A[AIndex - 1]);
      Result := Distance >= 2;
    end;
  CheckFalse(TArrayUtils.Some<Integer>(IA5, ICallback), 'Ia');
  CheckFalse(TArrayUtils.Some<Integer>(IA6, ICallback), 'Ib');
  CheckTrue(TArrayUtils.Some<Integer>(IA2, ICallback), 'Ic');
  CheckTrue(TArrayUtils.Some<Integer>(IA3, ICallback), 'Id');
  CheckFalse(TArrayUtils.Some<Integer>(IA1, ICallback), 'Ie');

  SCallback := function (const AElem: string; const AIndex: Integer;
    const A: array of string): Boolean
    var
      Count: Integer;
      Elem: string;
    begin
      // Checks if array contains duplicate of AElem
      Count := 0;
      for Elem in A do
        if Elem = AElem then
          Inc(Count);
      Result := Count >= 2;
    end;
  CheckTrue(TArrayUtils.Some<string>(SA5, SCallback), 'Sa');
  CheckFalse(TArrayUtils.Some<string>(SA1two, SCallback), 'Sb');
  CheckFalse(TArrayUtils.Some<string>(SA2, SCallback), 'Sc');
  CheckTrue(TArrayUtils.Some<string>(SA6, SCallback), 'Sd');

  PCallback := function (const AElem: TPoint; const AIndex: Integer;
    const A: array of TPoint): Boolean
    var
      Count: Integer;
      Elem: TPoint;
    begin
      // Checks if array contains duplicate of AElem
      Count := 0;
      for Elem in A do
        if PointEqualsFn(Elem, AElem) then
          Inc(Count);
      Result := Count >= 2;
    end;
  CheckTrue(TArrayUtils.Some<TPoint>(PA3, PCallback), 'Pa');
  CheckTrue(TArrayUtils.Some<TPoint>(PA2, PCallback), 'Pb');
  CheckFalse(TArrayUtils.Some<TPoint>(PA1, PCallback), 'Pc');
  CheckFalse(TArrayUtils.Some<TPoint>(PA4, PCallback), 'Pd');

  CheckException(Some_ExtendedCallback_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestSome_SimpleCallback_Overload;
var
  ICallback: TArrayUtils.TConstraint<Integer>;
  SCallback: TArrayUtils.TConstraint<string>;
  PCallback: TArrayUtils.TConstraint<TPoint>;
  OCallback: TArrayUtils.TConstraint<TTestObj>;
begin
  ICallback := function(const I: Integer): Boolean begin Result := I > 5; end;
  CheckTrue(TArrayUtils.Some<Integer>(IA2, ICallback), 'I1a');
  CheckTrue(TArrayUtils.Some<Integer>(IA6, ICallback), 'I1b');
  CheckFalse(TArrayUtils.Some<Integer>(IA5, ICallback), 'I1c');
  CheckTrue(TArrayUtils.Some<Integer>(IA1, ICallback), 'I1b');

  ICallback := function(const I: Integer): Boolean begin Result := Odd(I); end;
  CheckTrue(TArrayUtils.Some<Integer>(IA1, ICallback), 'I2a');
  CheckFalse(TArrayUtils.Some<Integer>(IA2, ICallback), 'I2b');
  CheckTrue(TArrayUtils.Some<Integer>(IA5, ICallback), 'I2c');

  SCallback := function(const S: string): Boolean begin Result := Length(S) >= 4; end;
  CheckTrue(TArrayUtils.Some<string>(SA1five, SCallback), 'Sa');
  CheckFalse(TArrayUtils.Some<string>(SA1two, SCallback), 'Sb');
  CheckTrue(TArrayUtils.Some<string>(SA3, SCallback), 'Sc');
  CheckFalse(TArrayUtils.Some<string>(SA6, SCallback), 'Sd');

  PCallback := function(const P: TPoint): Boolean begin Result := DistFromOrigin(P) > 6.0; end;

  CheckFalse(TArrayUtils.Some<TPoint>(PA2short, PCallback), 'Pa');
  CheckTrue(TArrayUtils.Some<TPoint>(PA2, PCallback), 'Pb');

  OCallback := function(const P: TTestObj): Boolean begin Result := P.B.IndexOf('a') >= 0; end;
  CheckTrue(TArrayUtils.Some<TTestObj>(OATwoPeeks, OCallback), 'Oa');
  CheckFalse(TArrayUtils.Some<TTestObj>(OA3, OCallback), 'Ob');

  CheckException(Some_SimpleCallback_Overload_AssertionFailure, EAssertionFailed, 'Assertion failure');
end;

procedure TestTArrayUtils.TestSort_ComparerFunc_Overload;
var
  IA, IExpected: TArray<Integer>;
  RevIntCompareFn: TComparison<Integer>;
  SA, SExpected: TArray<string>;
  PA, PExpected: TArray<TPoint>;
  OA, OExpected: TArray<TTestObj>;
begin
  RevIntCompareFn := function(const Left, Right: Integer): Integer
    begin
      Result := -IntCompareFn(Left, Right);
    end;

  IA := Copy(IA2Rev);
  TArrayUtils.Sort<Integer>(IA, IntCompareFn);
  IExpected := TArray<Integer>.Create();
  IExpected := Copy(IA2);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1');

  IA := Copy(IA5);
  TArrayUtils.Sort<Integer>(IA, IntCompareFn);
  IExpected := TArray<Integer>.Create(0, 0, 1, 1, 2, 2, 3, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2');

  IA := Copy(IA6);
  TArrayUtils.Sort<Integer>(IA, RevIntCompareFn);
  IExpected := TArray<Integer>.Create(9, 9, 9, 9, 9, 9, 8);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3');

  IA := Copy(IA0);
  TArrayUtils.Sort<Integer>(IA, IntCompareFn);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I4');

  SA := TArray<string>.Create('b', 'C', 'A', 'd');
  TArrayUtils.Sort<string>(SA, StrCompareStrFn);
  SExpected := TArray<string>.Create('A', 'C', 'b', 'd');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S1a');

  SA := TArray<string>.Create('b', 'C', 'A', 'd');
  TArrayUtils.Sort<string>(SA, StrCompareTextFn);
  SExpected := TArray<string>.Create('A', 'b', 'C', 'd');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S1b');

  SA := Copy(SA7);
  TArrayUtils.Sort<string>(SA, StrCompareStrFn);
  SExpected := TArray<string>.Create('five', 'one', 'one', 'three', 'three', 'two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S2');

  PA := Copy(PA3);
  TArrayUtils.Sort<TPoint>(PA, PointCompareFn);
  PExpected := TArray<TPoint>.Create(Pm8m9, Pm8m9, Pm1p5, Pm1p5, Pp1p3, Pp1p3);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA), 'P');

  OA := Copy(OA3);
  TArrayUtils.Sort<TTestObj>(OA, TestObjCompareFn);
  OExpected := TArray<TTestObj>.Create(O4, O2, O3, O5);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O');
end;

procedure TestTArrayUtils.TestSort_ComparerObj_Overload;
var
  IA, IExpected: TArray<Integer>;
  SA, SExpected: TArray<string>;
  PA, PExpected: TArray<TPoint>;
  OA, OExpected: TArray<TTestObj>;
begin
  IA := Copy(IA2Rev);
  TArrayUtils.Sort<Integer>(IA, IntegerComparer);
  IExpected := TArray<Integer>.Create();
  IExpected := Copy(IA2);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1');

  IA := Copy(IA5);
  TArrayUtils.Sort<Integer>(IA, IntegerComparer);
  IExpected := TArray<Integer>.Create(0, 0, 1, 1, 2, 2, 3, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2');

  IA := Copy(IA0);
  TArrayUtils.Sort<Integer>(IA, IntegerComparer);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3');

  SA := TArray<string>.Create('b', 'C', 'A', 'd');
  TArrayUtils.Sort<string>(SA, StringComparer);
  SExpected := TArray<string>.Create('A', 'C', 'b', 'd');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S1a');

  SA := TArray<string>.Create('b', 'C', 'A', 'd');
  TArrayUtils.Sort<string>(SA, TextComparer);
  SExpected := TArray<string>.Create('A', 'b', 'C', 'd');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S1b');

  SA := Copy(SA7);
  TArrayUtils.Sort<string>(SA, StringComparer);
  SExpected := TArray<string>.Create('five', 'one', 'one', 'three', 'three', 'two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S2');

  PA := Copy(PA3);
  TArrayUtils.Sort<TPoint>(PA, PointComparer);
  PExpected := TArray<TPoint>.Create(Pm8m9, Pm8m9, Pm1p5, Pm1p5, Pp1p3, Pp1p3);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA), 'P');

  OA := Copy(OA3);
  TArrayUtils.Sort<TTestObj>(OA, TestObjComparer);
  OExpected := TArray<TTestObj>.Create(O4, O2, O3, O5);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA, TestObjEqualsFn), 'O');
end;

procedure TestTArrayUtils.TestSort_NilComparer_Overload;
var
  IA, IExpected: TArray<Integer>;
  SA, SExpected: TArray<string>;
begin
  IA := Copy(IA2Rev);
  TArrayUtils.Sort<Integer>(IA);
  IExpected := TArray<Integer>.Create();
  IExpected := Copy(IA2);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1');

  IA := Copy(IA5);
  TArrayUtils.Sort<Integer>(IA);
  IExpected := TArray<Integer>.Create(0, 0, 1, 1, 2, 2, 3, 3, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2');

  IA := Copy(IA0);
  TArrayUtils.Sort<Integer>(IA);
  IExpected := TArray<Integer>.Create();
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3');

  SA := TArray<string>.Create('b', 'C', 'A', 'd');
  TArrayUtils.Sort<string>(SA);
  SExpected := TArray<string>.Create('A', 'C', 'b', 'd');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S1');

  SA := Copy(SA7);
  TArrayUtils.Sort<string>(SA);
  SExpected := TArray<string>.Create('five', 'one', 'one', 'three', 'three', 'two');
  CheckTrue(TArrayUtils.Equal<string>(SExpected, SA), 'S2');
end;

procedure TestTArrayUtils.TestTransform_ExtendedCallback_Overload;
var
  RomanSequenceTransformer: TArrayUtils.TTransformerEx<Integer,string>;
  Expected: TArray<string>;
  Got: TArray<string>;
begin
  RomanSequenceTransformer := function (const AValue: Integer; const AIndex: Integer; const A: array of Integer): string
    const
      Numerals: array[1..9] of string = ('I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX');

      function IntToRoman(I: Integer): string;
      begin
        if (I >= 1) and (I <= 9) then
          Result := Numerals[I]
        else
          Result := '?';
      end;
    var
      Idx: Integer;
    begin
      Result := '';
      for Idx := 0 to Pred(AIndex) do
        Result := Result + IntToRoman(A[Idx]) + ', ';
      Result := Result + IntToRoman(AValue);
    end;

  Got := TArrayUtils.Transform<Integer,string>(IA1, RomanSequenceTransformer);
  Expected := TArray<string>.Create('VII');
  CheckTrue(TArrayUtils.Equal<string>(Expected, Got, StrEqualsStrFn), 'RomanSequenceTransformer-1');

  Got := TArrayUtils.Transform<Integer,string>(IA2, RomanSequenceTransformer);
  Expected := TArray<string>.Create('II', 'II, IV', 'II, IV, VI', 'II, IV, VI, VIII');
  CheckTrue(TArrayUtils.Equal<string>(Expected, Got, StrEqualsStrFn), 'RomanSequenceTransformer-2');

  Got := TArrayUtils.Transform<Integer,string>(IA3Rev, RomanSequenceTransformer);
  Expected := TArray<string>.Create('IX', 'IX, VI', 'IX, VI, IV', 'IX, VI, IV, III', 'IX, VI, IV, III, I');
  CheckTrue(TArrayUtils.Equal<string>(Expected, Got, StrEqualsStrFn), 'RomanSequenceTransformer-3');

  Got := TArrayUtils.Transform<Integer,string>(IA0, RomanSequenceTransformer);
  Expected := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(Expected, Got, StrEqualsStrFn), 'RomanSequenceTransformer-4');
end;

procedure TestTArrayUtils.TestTransform_SimpleCallback_Overload;
var
  OutStrs, ExpectedStrs: TArray<string>;
  OutInts, ExpectedInts: TArray<Integer>;
  IA: TArray<Integer>;
  HexTransformer: TArrayUtils.TTransformer<Integer,string>;
  SquareTransformer: TArrayUtils.TTransformer<Integer,Integer>;
  LoCaseTransformer: TArrayUtils.TTransformer<string,string>;
  RomanTransformer: TArrayUtils.TTransformer<Integer,string>;
  PointTransformer: TArrayUtils.TTransformer<TPoint,string>;
  TestObjTransformer: TArrayUtils.TTransformer<TTestObj,string>;
begin
  HexTransformer := function (const AValue: Integer): string
    begin
      Result := IntToHex(AValue, 2);
    end;
  SquareTransformer := function (const AValue: Integer): Integer
    begin
      Result := AValue * AValue;
    end;
  LoCaseTransformer := function (const AValue: string): string
    begin
      Result := LowerCase(AValue);
    end;
  RomanTransformer := function (const AValue: Integer): string
    const
      Numerals: array[1..9] of string = ('I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX');
    begin
      if (AValue >= 1) and (AValue <= 9) then
        Result := Numerals[AValue]
      else
        Result := '?';
    end;
  PointTransformer := function (const AValue: TPoint): string
    begin
      Result := Format('(%d,%d)', [AValue.X, AValue.Y]);
    end;
  TestObjTransformer := function (const AValue: TTestObj): string
    begin
      Result := AValue.A;
    end;

  IA := TArray<Integer>.Create(12, 33, 42, 56);
  ExpectedStrs := TArray<string>.Create('0C', '21', '2A', '38');
  OutStrs := TArrayUtils.Transform<Integer,string>(IA, HexTransformer);
  CheckTrue(TArrayUtils.Equal<string>(ExpectedStrs, OutStrs, StrEqualsStrFn), 'Hex-1');

  OutStrs := TArrayUtils.Transform<Integer,string>(IA0, HexTransformer);
  ExpectedStrs := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(ExpectedStrs, OutStrs, StrEqualsStrFn), 'Hex-2');

  OutStrs := TArrayUtils.Transform<string,string>(SA2DupIgnoreCase, LoCaseTransformer);
  ExpectedStrs := SA2;
  CheckTrue(TArrayUtils.Equal<string>(ExpectedStrs, OutStrs, StrEqualsStrFn), 'LoCase');

  OutInts := TArrayUtils.Transform<Integer,Integer>(IA2Rev, SquareTransformer);
  ExpectedInts := TArray<Integer>.Create(64, 36, 16, 4);
  CheckTrue(TArrayUtils.Equal<Integer>(ExpectedInts, OutInts, IntEqualsFn), 'Square');

  OutStrs := TArrayUtils.Transform<Integer,string>(IA3Rev, RomanTransformer);
  ExpectedStrs := TArray<string>.Create('IX', 'VI', 'IV', 'III', 'I');
  CheckTrue(TArrayUtils.Equal<string>(ExpectedStrs, OutStrs, StrEqualsStrFn), 'Roman');

  OutStrs := TArrayUtils.Transform<TPoint,string>(PA2short, PointTransformer);
  ExpectedStrs := TArray<string>.Create('(1,3)', '(1,3)', '(-1,5)');
  CheckTrue(TArrayUtils.Equal<string>(ExpectedStrs, OutStrs, StrEqualsStrFn), 'Point-1');

  OutStrs := TArrayUtils.Transform<TPoint,string>(PA0, PointTransformer);
  ExpectedStrs := TArray<string>.Create();
  CheckTrue(TArrayUtils.Equal<string>(ExpectedStrs, OutStrs, StrEqualsStrFn), 'Point-2');

  OutStrs := TArrayUtils.Transform<TPoint,string>(PA3, PointTransformer);
  ExpectedStrs := TArray<string>.Create('(1,3)', '(-1,5)', '(-8,-9)', '(-8,-9)', '(-1,5)', '(1,3)');
  CheckTrue(TArrayUtils.Equal<string>(ExpectedStrs, OutStrs, StrEqualsStrFn), 'Point-3');

  OutStrs := TArrayUtils.Transform<TTestObj,string>(OA3, TestObjTransformer);
  ExpectedStrs := TArray<string>.Create('@', 'd', 'c', 'b');
  CheckTrue(TArrayUtils.Equal<string>(ExpectedStrs, OutStrs, StrEqualsStrFn), 'TestObj-1');
end;

procedure TestTArrayUtils.TestTryFindLast_ExtendedCallback_Overload;
var
  IsPeakElem: TArrayUtils.TConstraintEx<Integer>;
  IsPeakLongestStr: TArrayUtils.TConstraintEx<string>;
  FS: string;
  FI: Integer;
  RB: Boolean;
begin
  IsPeakElem := function (const AElem: Integer; const AIndex: Integer;
    const A: array of Integer): Boolean
    begin
      if Length(A) = 0 then
        Exit(False);
      if Length(A) = 1 then
        Exit(True);
      // Length(A) >= 2
      if (AIndex = 0) then
        // 1st elem: peak if next elem smaller
        Result := A[Succ(AIndex)] < AElem
      else if AIndex = Pred(Length(A)) then
        // last elem: peak if previous elem smaller
        Result := A[Pred(AIndex)] < AElem
      else
        // not 1st or last: peak if > than elems on either side
        Result := (A[Succ(AIndex)] < AElem) and (A[Pred(AIndex)] < AElem);
    end;

  RB := TArrayUtils.TryFindLast<Integer>(IA2, IsPeakElem, FI);
  CheckTrue(RB, 'I1 result');
  CheckEquals(8, FI, 'I1 item');

  RB := TArrayUtils.TryFindLast<Integer>(IA2Rev, IsPeakElem, FI);
  CheckTrue(RB, 'I2 result');
  CheckEquals(8, FI, 'I2 item');

  RB := TArrayUtils.TryFindLast<Integer>(IA5, IsPeakElem, FI);
  CheckTrue(RB, 'I3 result');
  CheckEquals(4, FI, 'I3 item');

  RB := TArrayUtils.TryFindLast<Integer>(IA6, IsPeakElem, FI);
  CheckFalse(RB, 'I4 result');

  RB := TArrayUtils.TryFindLast<Integer>(IA7, IsPeakElem, FI);
  CheckTrue(RB, 'I5 result');
  CheckEquals(8, FI, 'I5 item');

  RB := TArrayUtils.TryFindLast<Integer>(IA1, IsPeakElem, FI);
  CheckTrue(RB, 'I6 result');
  CheckEquals(7, FI, 'I6 item');

  RB := TArrayUtils.TryFindLast<Integer>(IA0, IsPeakElem, FI);
  CheckFalse(RB, 'I7 result');

  IsPeakLongestStr := function (const AElem: string; const AIndex: Integer;
    const A: array of string): Boolean
    begin
      if Length(A) = 0 then
        Exit(False);
      if Length(A) = 1 then
        Exit(True);
      // Length(A) >= 2
      if (AIndex = 0) then
        // 1st elem: peak if next elem shorter
        Result := Length(A[Succ(AIndex)]) < Length(AElem)
      else if AIndex = Pred(Length(A)) then
        // last elem: peak if previous elem shorter
        Result := Length(A[Pred(AIndex)]) < Length(AElem)
      else
        // not 1st or last: peak if longer than elems on either side
        Result := (Length(A[Succ(AIndex)]) < Length(AElem))
          and (Length(A[Pred(AIndex)]) < Length(AElem));
    end;

  RB := TArrayUtils.TryFindLast<string>(SA4, IsPeakLongestStr, FS);
  CheckTrue(RB, 'S1 result');
  CheckEquals('seven', FS, 'S1 item');

  RB := TArrayUtils.TryFindLast<string>(SA7, IsPeakLongestStr, FS);
  CheckTrue(RB, 'S2 result');
  CheckEquals('three', FS, 'S2 item');

  RB := TArrayUtils.TryFindLast<string>(SA2, IsPeakLongestStr, FS);
  CheckTrue(RB, 'S3 result');
  CheckEquals('eight', FS, 'S3 item');

  RB := TArrayUtils.TryFindLast<string>(SA2Rev, IsPeakLongestStr, FS);
  CheckTrue(RB, 'S4 result');
  CheckEquals('four', FS, 'S4 item');

  RB := TArrayUtils.TryFindLast<string>(SA1two, IsPeakLongestStr, FS);
  CheckTrue(RB, 'S5 result');
  CheckEquals('two', FS, 'S5 item');
end;

procedure TestTArrayUtils.TestTryFindLast_SimpleCallback_Overload;
var
  FS: string;
  FI: Integer;
  FP: TPoint;
  FO: TTestObj;
  RB: Boolean;
begin
  RB := TArrayUtils.TryFindLast<string>(
    SA7,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 't'; end,
    FS
  );
  CheckEquals('two', FS, 'S1 item');
  CheckTrue(RB, 'S1 result');

  RB := TArrayUtils.TryFindLast<string>(
    SA1five,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 'f'; end,
    FS
  );
  CheckEquals('five', FS, 'S2 item');
  CheckTrue(RB, 'S2 result');

  RB := TArrayUtils.TryFindLast<string>(
    SA1two,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 'f'; end,
    FS
  );
  CheckFalse(RB, 'S3 result');

  RB := TArrayUtils.TryFindLast<Integer>(
    IA5,
    function (const I: Integer): Boolean begin Result := I > 2; end,
    FI
  );
  CheckEquals(3, FI, 'I1 item');
  CheckTrue(RB, 'I1 result');

  RB := TArrayUtils.TryFindLast<Integer>(
    IA0,
    function (const I: Integer): Boolean begin Result := I > 2; end,
    FI
  );
  CheckFalse(RB, 'I2 result');

  RB := TArrayUtils.TryFindLast<Integer>(
    IA5,
    function (const I: Integer): Boolean begin Result := I >= 0; end,
    FI
  );
  CheckEquals(0, FI, 'I3 item');
  CheckTrue(RB, 'I3 result');

  RB := TArrayUtils.TryFindLast<Integer>(
    IA2,
    function (const I: Integer): Boolean begin Result := Odd(I); end,
    FI
  );
  CheckFalse(RB, 'I4 result');

  RB := TArrayUtils.TryFindLast<Integer>(
    IA6,
    function (const I: Integer): Boolean begin Result := not Odd(I); end,
    FI
  );
  CheckEquals(8, FI, 'I5 item');
  CheckTrue(RB, 'I5 result');

  RB := TArrayUtils.TryFindLast<Integer>(
    IA6,
    function (const I: Integer): Boolean begin Result := Odd(I); end,
    FI
  );
  CheckEquals(9, FI, 'I6 item');
  CheckTrue(RB, 'I6 result');

  RB := TArrayUtils.TryFindLast<TPoint>(
    PA2,
    function (const P: TPoint): Boolean
    begin
      // point with distance from origin > 5
      Result := DistFromOrigin(P) > 5.0;
    end,
    FP
  );
  CheckTrue(PointEqualsFn(Pp12p5, FP), 'P1 item');
  CheckTrue(RB, 'P1 result');

  RB := TArrayUtils.TryFindLast<TPoint>(
    PA2,
    function (const P: TPoint): Boolean begin Result := PointEqualsFn(P, Pmissing) end,
    FP
  );
  CheckFalse(RB, 'P2 result');

  RB := TArrayUtils.TryFindLast<TPoint>(
    PA2short,
    function (const P: TPoint): Boolean
    begin
      // point with distance from origin < 3.5
      Result := DistFromOrigin(P) < 3.5;
    end,
    FP
  );
  CheckTrue(PointEqualsFn(Pp1p3Dup, FP), 'P3 item');
  CheckTrue(RB, 'P3 result');

  RB := TArrayUtils.TryFindLast<TTestObj>(
    OATwoPeeks,
    function (const O: TTestObj): Boolean
    begin
      Result := O.B.IndexOf('d') > -1;
    end,
    FO
  );
  CheckTrue(O2.Equals(FO), 'O1 item');
  CheckTrue(RB, 'O1 result');

  RB := TArrayUtils.TryFindLast<TTestObj>(
    OATwoPeeks,
    function (const O: TTestObj): Boolean
    begin
      Result := O.A = '?';
    end,
    FO
  );
  CheckFalse(RB, 'O2 result');
end;

procedure TestTArrayUtils.TestTryFind_ExtendedCallback_Overload;
var
  IsPeakElem: TArrayUtils.TConstraintEx<Integer>;
  IsPeakLongestStr: TArrayUtils.TConstraintEx<string>;
  FS: string;
  FI: Integer;
  RB: Boolean;
begin
  IsPeakElem := function (const AElem: Integer; const AIndex: Integer;
    const A: array of Integer): Boolean
    begin
      if Length(A) = 0 then
        Exit(False);
      if Length(A) = 1 then
        Exit(True);
      // Length(A) >= 2
      if (AIndex = 0) then
        // 1st elem: peak if next elem smaller
        Result := A[Succ(AIndex)] < AElem
      else if AIndex = Pred(Length(A)) then
        // last elem: peak if previous elem smaller
        Result := A[Pred(AIndex)] < AElem
      else
        // not 1st or last: peak if > than elems on either side
        Result := (A[Succ(AIndex)] < AElem) and (A[Pred(AIndex)] < AElem);
    end;

  RB := TArrayUtils.TryFind<Integer>(IA2, IsPeakElem, FI);
  CheckTrue(RB, 'I1 result');
  CheckEquals(8, FI, 'I1 item');

  RB := TArrayUtils.TryFind<Integer>(IA2Rev, IsPeakElem, FI);
  CheckTrue(RB, 'I2 result');
  CheckEquals(8, FI, 'I2 item');

  RB := TArrayUtils.TryFind<Integer>(IA5, IsPeakElem, FI);
  CheckTrue(RB, 'I3 result');
  CheckEquals(4, FI, 'I3 item');

  RB := TArrayUtils.TryFind<Integer>(IA6, IsPeakElem, FI);
  CheckFalse(RB, 'I4 result');

  RB := TArrayUtils.TryFind<Integer>(IA7, IsPeakElem, FI);
  CheckTrue(RB, 'I5 result');
  CheckEquals(6, FI, 'I5 item');

  RB := TArrayUtils.TryFind<Integer>(IA1, IsPeakElem, FI);
  CheckTrue(RB, 'I6 result');
  CheckEquals(7, FI, 'I6 item');

  RB := TArrayUtils.TryFind<Integer>(IA0, IsPeakElem, FI);
  CheckFalse(RB, 'I7 result');

  IsPeakLongestStr := function (const AElem: string; const AIndex: Integer;
    const A: array of string): Boolean
    begin
      if Length(A) = 0 then
        Exit(False);
      if Length(A) = 1 then
        Exit(True);
      // Length(A) >= 2
      if (AIndex = 0) then
        // 1st elem: peak if next elem shorter
        Result := Length(A[Succ(AIndex)]) < Length(AElem)
      else if AIndex = Pred(Length(A)) then
        // last elem: peak if previous elem shorter
        Result := Length(A[Pred(AIndex)]) < Length(AElem)
      else
        // not 1st or last: peak if longer than elems on either side
        Result := (Length(A[Succ(AIndex)]) < Length(AElem))
          and (Length(A[Pred(AIndex)]) < Length(AElem));
    end;

  RB := TArrayUtils.TryFind<string>(SA4, IsPeakLongestStr, FS);
  CheckTrue(RB, 'S1 result');
  CheckEquals('three', FS, 'S1 item');

  RB := TArrayUtils.TryFind<string>(SA7, IsPeakLongestStr, FS);
  CheckTrue(RB, 'S2 result');
  CheckEquals('three', FS, 'S2 item');

  RB := TArrayUtils.TryFind<string>(SA2, IsPeakLongestStr, FS);
  CheckTrue(RB, 'S3 result');
  CheckEquals('four', FS, 'S3 item');

  RB := TArrayUtils.TryFind<string>(SA2Rev, IsPeakLongestStr, FS);
  CheckTrue(RB, 'S4 result');
  CheckEquals('eight', FS, 'S4 item');

  RB := TArrayUtils.TryFind<string>(SA1two, IsPeakLongestStr, FS);
  CheckTrue(RB, 'S5 result');
  CheckEquals('two', FS, 'S5 item');
end;

procedure TestTArrayUtils.TestTryFind_SimpleCallback_Overload;
var
  FS: string;
  FI: Integer;
  FP: TPoint;
  FO: TTestObj;
  RB: Boolean;
begin
  RB := TArrayUtils.TryFind<string>(
    SA7,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 't'; end,
    FS
  );
  CheckEquals('three', FS, 'S1 item');
  CheckTrue(RB, 'S1 result');

  RB := TArrayUtils.TryFind<string>(
    SA1five,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 'f'; end,
    FS
  );
  CheckEquals('five', FS, 'S2 item');
  CheckTrue(RB, 'S2 result');

  RB := TArrayUtils.TryFind<string>(
    SA1two,
    function (const S: string): Boolean begin Result := (S + '.')[1] = 'f'; end,
    FS
  );
  CheckFalse(RB, 'S3 result');

  RB := TArrayUtils.TryFind<Integer>(
    IA5,
    function (const I: Integer): Boolean begin Result := I > 2; end,
    FI
  );
  CheckEquals(3, FI, 'I1 item');
  CheckTrue(RB, 'I1 result');

  RB := TArrayUtils.TryFind<Integer>(
    IA0,
    function (const I: Integer): Boolean begin Result := I > 2; end,
    FI
  );
  CheckFalse(RB, 'I2 result');

  RB := TArrayUtils.TryFind<Integer>(
    IA5,
    function (const I: Integer): Boolean begin Result := I >= 0; end,
    FI
  );
  CheckEquals(0, FI, 'I3 item');
  CheckTrue(RB, 'I3 result');

  RB := TArrayUtils.TryFind<Integer>(
    IA2,
    function (const I: Integer): Boolean begin Result := Odd(I); end,
    FI
  );
  CheckFalse(RB, 'I4 result');

  RB := TArrayUtils.TryFind<TPoint>(
    PA2,
    function (const P: TPoint): Boolean
    begin
      // point with distance from origin > 5
      Result := DistFromOrigin(P) > 5.0;
    end,
    FP
  );
  CheckTrue(PointEqualsFn(Pm1p5, FP), 'P1 item');
  CheckTrue(RB, 'P1 result');

  RB := TArrayUtils.TryFind<TPoint>(
    PA2,
    function (const P: TPoint): Boolean begin Result := PointEqualsFn(P, Pmissing) end,
    FP
  );
  CheckFalse(RB, 'P2 result');

  RB := TArrayUtils.TryFind<TTestObj>(
    OATwoPeeks,
    function (const O: TTestObj): Boolean
    begin
      Result := O.B.IndexOf('d') > -1;
    end,
    FO
  );
  CheckTrue(O1.Equals(FO), 'O1 item');
  CheckTrue(RB, 'O1 result');

  RB := TArrayUtils.TryFind<TTestObj>(
    OATwoPeeks,
    function (const O: TTestObj): Boolean
    begin
      Result := O.A = '?';
    end,
    FO
  );
  CheckFalse(RB, 'O2 result');
end;

procedure TestTArrayUtils.TestUnShift;
var
  IA, IExpected: TArray<Integer>;
  SA, SExpected: TArray<string>;
  PA, PExpected: TArray<TPoint>;
  OA, OExpected: TArray<TTestObj>;
begin
  IA := Copy(IA0);

  TArrayUtils.UnShift<Integer>(IA, 42);
  IExpected := TArray<Integer>.Create(42);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I1');

  IA := Copy(IA1);

  TArrayUtils.UnShift<Integer>(IA, 9);
  IExpected := TArray<Integer>.Create(9, 7);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2a');

  TArrayUtils.UnShift<Integer>(IA, 11);
  IExpected := TArray<Integer>.Create(11, 9, 7);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I2b');

  IA := Copy(IA4);

  TArrayUtils.UnShift<Integer>(IA, 11);
  IExpected := TArray<Integer>.Create(11, 1, 3, 5, 7, 9);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3a');

  TArrayUtils.UnShift<Integer>(IA, 13);
  IExpected := TArray<Integer>.Create(13, 11, 1, 3, 5, 7, 9);
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'I3b');

  SA := Copy(SA5);

  TArrayUtils.UnShift<string>(SA, 'three');
  SExpected := TArray<string>.Create( 'three', 'one', 'two', 'one', 'two');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'Sa');

  TArrayUtils.UnShift<string>(SA, 'four');
  SExpected := TArray<string>.Create('four', 'three', 'one', 'two', 'one', 'two');
  CheckTrue(TArrayUtils.Equal<Integer>(IExpected, IA), 'Sb');

  PA := Copy(PA0);

  TArrayUtils.UnShift<TPoint>(PA, Pp1p3);
  PExpected := TArray<TPoint>.Create(Pp1p3);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA), 'P1');

  TArrayUtils.UnShift<TPoint>(PA, Pm8m9);
  PExpected := TArray<TPoint>.Create(Pm8m9, Pp1p3);
  CheckTrue(TArrayUtils.Equal<TPoint>(PExpected, PA), 'P2');

  OA := Copy(OA1);

  TArrayUtils.UnShift<TTestObj>(OA, O5);
  OExpected := TArray<TTestObj>.Create(O5, O1);
  CheckTrue(TArrayUtils.Equal<TTestObj>(OExpected, OA), 'O');
end;

{ TIntegerComparer }

function TIntegerComparer.Compare(const Left, Right: Integer): Integer;
begin
  Result := Left - Right;
end;

function TIntegerComparer.Equals(const Left, Right: Integer): Boolean;
begin
  Result := Left = Right;
end;

function TIntegerComparer.GetHashCode(const Value: Integer): Integer;
begin
  Result := Value;
end;

{ TStringComparer }

function TStringComparer.Compare(const Left, Right: string): Integer;
begin
  Result := CompareStr(Left, Right);
end;

function TStringComparer.Equals(const Left, Right: string): Boolean;
begin
  Result := SameStr(Left, Right);
end;

function TStringComparer.GetHashCode(const Value: string): Integer;
begin
  Result := StringHash(Value);
end;

{ TTextComparer }

function TTextComparer.Compare(const Left, Right: string): Integer;
begin
  Result := CompareStr(UpperCase(Left), UpperCase(Right));
end;

function TTextComparer.Equals(const Left, Right: string): Boolean;
begin
  Result := SameStr(UpperCase(Left), UpperCase(Right));
end;

function TTextComparer.GetHashCode(const Value: string): Integer;
begin
  Result := StringHash(UpperCase(Value));
end;

{ TPointComparer }

function TPointComparer.Compare(const Left, Right: TPoint): Integer;
begin
  Result := Left.X - Right.X;
  if Result = 0 then
    Result := Left.Y - Right.Y;
end;

function TPointComparer.Equals(const Left, Right: TPoint): Boolean;
begin
  Result := (Left.X = Right.X) and (Left.Y = Right.Y);
end;

function TPointComparer.GetHashCode(const Value: TPoint): Integer;
begin
  {$IFDEF HasSystemHashUnit}
  Result := THashBobJenkins.GetHashValue(Value, SizeOf(Value), 0);
  {$ELSE}
  Result := BobJenkinsHash(Value, SizeOf(Value), 0);
  {$ENDIF}
end;

{ TestTArrayUtils.TTestObj }

function TestTArrayUtils.TTestObj.Clone: TTestObj;
begin
  Result := TTestObj.Create(fA, fB.ToStringArray);
end;

function TestTArrayUtils.TTestObj.Compare(Other: TTestObj): Integer;
var
  Str, OtherStr: string;
begin
  Str := fA + fB.Text;
  OtherStr := Other.fA + Other.fB.Text;
  Result := CompareStr(Str, OtherStr);
end;

class constructor TestTArrayUtils.TTestObj.Create;
begin
  fInstanceCount := 0;
end;

constructor TestTArrayUtils.TTestObj.Create(const S: string;
  const Strs: TArray<string>);
var
  Elem: string;
begin
  Inc(fInstanceCount);
  inherited Create;
  fA := S;
  fB := TStringList.Create;
  for Elem in Strs do
    fB.Add(Elem);
end;

destructor TestTArrayUtils.TTestObj.Destroy;
begin
  fB.Free;
  inherited;
  Dec(fInstanceCount);
end;

function TestTArrayUtils.TTestObj.Equals(Other: TTestObj): Boolean;
begin
  Result := Compare(Other) = 0;
end;

procedure TestTArrayUtils.TTestObj.SetB(const SL: TStrings);
begin
  fB.Assign(SL);
end;

{ TestTArrayUtils.TTestObjComparer }

function TestTArrayUtils.TTestObjComparer.Compare(const Left,
  Right: TTestObj): Integer;
begin
  Result := Left.Compare(Right);
end;

function TestTArrayUtils.TTestObjComparer.Equals(const Left,
  Right: TTestObj): Boolean;
begin
  Result := Left.Equals(Right);
end;

function TestTArrayUtils.TTestObjComparer.GetHashCode(
  const Value: TTestObj): Integer;
begin
  Result := Value.GetHashCode;
end;

{ TestTArrayUtils.TTestResource }

constructor TestTArrayUtils.TTestResource.Create(const S: string;
  const I: Integer);
begin
  fS := S;
  fI := I;
  Inc(fInstanceCount);
end;

procedure TestTArrayUtils.TTestResource.Release;
begin
  Dec(fInstanceCount);
end;

class constructor TestTArrayUtils.TTestResource.Create;
begin
  fInstanceCount := 0;
end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTArrayUtils.Suite);

end.

