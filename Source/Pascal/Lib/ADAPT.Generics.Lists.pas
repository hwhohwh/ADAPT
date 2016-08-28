{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Lists;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Generics.Common.Intf,
  ADAPT.Generics.Allocators.Intf,
  ADAPT.Generics.Comparers.Intf,
  ADAPT.Generics.Sorters.Intf,
  ADAPT.Generics.Arrays.Intf,
  ADAPT.Generics.Lists.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>Generic List Type</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADList<T> = class(TADObject, IADList<T>, IADIterable<T>, IADListSortable<T>, IADExpandable, IADCompactable)
  private
    FCompactor: IADCollectionCompactor;
    FExpander: IADCollectionExpander;
    FInitialCapacity: Integer;
    FSortedState: TADSortedState;
    FSorter: IADListSorter<T>;
  protected
    FArray: IADArray<T>;
    FCount: Integer;

    // Getters
    { IADCollection }
    function GetCapacity: Integer; virtual;
    function GetCount: Integer; virtual;
    function GetInitialCapacity: Integer;
    function GetIsCompact: Boolean; virtual;
    function GetIsEmpty: Boolean; virtual;
    function GetSortedState: TADSortedState; virtual;
    { IADCompactable }
    function GetCompactor: IADCollectionCompactor; virtual;
    { IADExpandable }
    function GetExpander: IADCollectionExpander; virtual;
    { IADListSortable<T> }
    function GetSorter: IADListSorter<T>; virtual;
    { IADList<T> }
    function GetItem(const AIndex: Integer): T; virtual;

    // Setters
    { IADCollection }
    procedure SetCapacity(const ACapacity: Integer); virtual;
    { IADCompactable }
    procedure SetCompactor(const ACompactor: IADCollectionCompactor); virtual;
    { IADExpandable }
    procedure SetExpander(const AExpander: IADCollectionExpander); virtual;
    { IADListSortable<T> }
    procedure SetSorter(const ASorter: IADListSorter<T>); virtual;
    { IADList<T> }
    procedure SetItem(const AIndex: Integer; const AItem: T); virtual;

    // Management Methods
    ///  <summary><c>Adds the Item to the first available Index of the Array WITHOUT checking capacity.</c></summary>
    procedure AddActual(const AItem: T);
    ///  <summary><c>Override to construct an alternative Array type</c></summary>
    procedure CreateArray(const AInitialCapacity: Integer = 0); virtual;
    ///  <summary><c>Compacts the Array according to the given Compactor Algorithm.</c></summary>
    procedure CheckCompact(const AAmount: Integer); virtual;
    ///  <summary><c>Expands the Array according to the given Expander Algorithm.</c></summary>
    procedure CheckExpand(const AAmount: Integer); virtual;
  public
    ///  <summary><c>Creates an instance of your List using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    destructor Destroy; override;
    // Management Methods
    procedure Add(const AItem: T); overload; virtual;
    procedure Add(const AList: IADList<T>); overload; virtual;
    procedure AddItems(const AItems: Array of T); virtual;
    procedure Clear; virtual;
    procedure Compact; virtual;
    procedure Delete(const AIndex: Integer); virtual;
    procedure DeleteRange(const AFirst, ACount: Integer); virtual;
    procedure Insert(const AItem: T; const AIndex: Integer); virtual;
    procedure InsertItems(const AItems: Array of T; const AIndex: Integer); virtual;
    procedure Sort(const AComparer: IADComparer<T>); virtual;
    // Iterators
    { IADIterable<T> }
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight); overload; inline;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection = idRight); overload; inline;
    procedure Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection = idRight); overload; inline;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateBackward(const ACallback: TADListItemCallbackAnon<T>); overload; virtual;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateBackward(const ACallback: TADListItemCallbackOfObject<T>); overload; virtual;
    procedure IterateBackward(const ACallback: TADListItemCallbackUnbound<T>); overload; virtual;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateForward(const ACallback: TADListItemCallbackAnon<T>); overload; virtual;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateForward(const ACallback: TADListItemCallbackOfObject<T>); overload; virtual;
    procedure IterateForward(const ACallback: TADListItemCallbackUnbound<T>); overload; virtual;
    // Properties
    { IADCollection }
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount;
    property InitialCapacity: Integer read GetInitialCapacity;
    property IsCompact: Boolean read GetIsCompact;
    property IsEmpty: Boolean read GetIsEmpty;
    property SortedState: TADSortedState read GetSortedState;
    { IADCompactable }
    property Compactor: IADCollectionCompactor read GetCompactor;
    { IADExpandable }
    property Expander: IADCollectionExpander read GetExpander;
    { IADList<T> }
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
  end;

  ///  <summary><c>Generic Object List Type</c></summary>
  ///  <remarks>
  ///    <para><c>Can take Ownership of its Items.</c></para>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADObjectList<T: class> = class(TADList<T>, IADObjectOwner)
  protected
    // Getters
    function GetOwnership: TADOwnership; virtual;
    // Setters
    procedure SetOwnership(const AOwnership: TADOwnership); virtual;
    // Management Methods
    ///  <summary><c>We need a TADObjectArray instead.</c></summary>
    procedure CreateArray(const AInitialCapacity: Integer = 0); override;
  public
    ///  <summary><c>Creates an instance of your List using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload;
    ///  <summary><c>Creates an instance of your List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0; const AOwnership: TADOwnership = oOwnsObjects); reintroduce; overload; virtual;

    // Properties
    property Ownership: TADOwnership read GetOwnership write SetOwnership;
  end;

  ///  <summary><c>A Generic Fixed-Capacity Revolving List</c></summary>
  ///  <remarks>
  ///    <para><c>When the current Index is equal to the Capacity, the Index resets to 0, and items are subsequently Replaced by new ones.</c></para>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADCircularList<T> = class(TADObject, IADCircularList<T>, IADIterable<T>)
  private
    FCount: Integer;
    FInitialCapacity: Integer;
    FItems: IADArray<T>;
  protected
    // Getters
    { IADCollection }
    function GetCapacity: Integer; virtual;
    function GetCount: Integer; virtual;
    function GetInitialCapacity: Integer;
    function GetSortedState: TADSortedState; virtual;
    { IADCircularList<T> }
    function GetItem(const AIndex: Integer): T; virtual;
    function GetIsCompact: Boolean; virtual;
    function GetIsEmpty: Boolean; virtual;
    function GetNewest: T; virtual;
    function GetNewestIndex: Integer; virtual;
    function GetOldest: T; virtual;
    function GetOldestIndex: Integer; virtual;

    // Setters
    { IADCircularList<T> }
    procedure SetCapacity(const ACapacity: Integer); virtual;

    // Management Methods
    { IADCircularList<T> }
    function AddActual(const AItem: T): Integer; virtual;
    procedure CreateItemArray(const ACapacity: Integer); virtual;
  public
    constructor Create(const ACapacity: Integer); reintroduce; virtual;
    destructor Destroy; override;
    // Management Methods
    function Add(const AItem: T): Integer; virtual;
    procedure AddItems(const AItems: Array of T); virtual;
    procedure Clear; virtual;
    procedure Delete(const AIndex: Integer); virtual;
    // Iterators
    { IADIterable<T> }
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight); overload; inline;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection = idRight); overload; inline;
    procedure Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection = idRight); overload; inline;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateBackward(const ACallback: TADListItemCallbackAnon<T>); overload; virtual;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateBackward(const ACallback: TADListItemCallbackOfObject<T>); overload; virtual;
    procedure IterateBackward(const ACallback: TADListItemCallbackUnbound<T>); overload; virtual;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateForward(const ACallback: TADListItemCallbackAnon<T>); overload; virtual;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateForward(const ACallback: TADListItemCallbackOfObject<T>); overload; virtual;
    procedure IterateForward(const ACallback: TADListItemCallbackUnbound<T>); overload; virtual;
    // Properties
    property Capacity: Integer read GetCapacity;
    property Count: Integer read GetCount;
    property Items[const AIndex: Integer]:  T read GetItem;// write SetItem;
    property Newest: T read GetNewest;
    property NewestIndex: Integer read GetNewestIndex;
    property Oldest: T read GetOldest;
    property OldestIndex: Integer read GetOldestIndex;
  end;

  ///  <summary><c>A Generic Fixed-Capacity Revolving Object List</c></summary>
  ///  <remarks>
  ///    <para><c>When the current Index is equal to the Capacity, the Index resets to 0, and items are subsequently Replaced by new ones.</c></para>
  ///    <para><c>Can take Ownership of its Items.</c></para>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADCircularObjectList<T: class> = class(TADCircularList<T>, IADObjectOwner)
  private
    FDefaultOwnership: TADOwnership;
  protected
    // Getters
    function GetOwnership: TADOwnership; virtual;
    // Setters
    procedure SetOwnership(const AOwnership: TADOwnership); virtual;
  protected
    procedure CreateItemArray(const ACapacity: Integer); override;
  public
    constructor Create(const AOwnership: TADOwnership; const ACapacity: Integer); reintroduce; virtual;
    destructor Destroy; override;
  end;

  ///  <summary><c>Generic Sorted List Type.</c></summary>
  ///  <remarks>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADSortedList<T> = class(TADObject, IADSortedList<T>, IADComparable<T>, IADIterable<T>, IADListSortable<T>, IADCompactable, IADExpandable)
  private
    FCompactor: IADCollectionCompactor;
    FComparer: IADComparer<T>;
    FExpander: IADCollectionExpander;
    FInitialCapacity: Integer;
    FSorter: IADListSorter<T>;
  protected
    FArray: IADArray<T>;
    FCount: Integer;

    // Getters
    { IADCompactable }
    function GetCompactor: IADCollectionCompactor; virtual;
    { IADComparable<T> }
    function GetComparer: IADComparer<T>; virtual;
    { IADExpandable }
    function GetExpander: IADCollectionExpander; virtual;
    { IADListSortable<T> }
    function GetSorter: IADListSorter<T>; virtual;
    { IADSortedList<T> }
    function GetCapacity: Integer; virtual;
    function GetCount: Integer; virtual;
    function GetInitialCapacity: Integer;
    function GetIsCompact: Boolean; virtual;
    function GetIsEmpty: Boolean; virtual;
    function GetItem(const AIndex: Integer): T; virtual;
    function GetSortedState: TADSortedState;

    // Setters
    { IADCompactable }
    procedure SetCompactor(const ACompactor: IADCollectionCompactor); virtual;
    { IADComparable<T> }
    procedure SetComparer(const AComparer: IADComparer<T>); virtual;
    { IADExpandable }
    procedure SetExpander(const AExpander: IADCollectionExpander); virtual;
    { IADListSortable<T> }
    procedure SetSorter(const ASorter: IADListSorter<T>); virtual;
    { IADSortedList<T> }
    procedure SetCapacity(const ACapacity: Integer); virtual;

    // Management Methods
    ///  <summary><c>Adds the Item to the correct Index of the Array WITHOUT checking capacity.</c></summary>
    ///  <returns>
    ///    <para>-1<c> if the Item CANNOT be added.</c></para>
    ///    <para>0 OR GREATER<c> if the Item has be added, where the Value represents the Index of the Item.</c></para>
    ///  </returns>
    function AddActual(const AItem: T): Integer;
    ///  <summary><c>Compacts the Array according to the given Compactor Algorithm.</c></summary>
    procedure CheckCompact(const AAmount: Integer); virtual;
    ///  <summary><c>Expands the Array according to the given Expander Algorithm.</c></summary>
    procedure CheckExpand(const AAmount: Integer); virtual;
    ///  <summary><c>Override to construct an alternative Array type</c></summary>
    procedure CreateArray(const AInitialCapacity: Integer = 0); virtual;
    ///  <summary><c>Determines the Index at which an Item would need to be Inserted for the List to remain in-order.</c></summary>
    ///  <remarks>
    ///    <para><c>This is basically a Binary Sort implementation.<c></para>
    ///  </remarks>
    function GetSortedPosition(const AItem: T): Integer; virtual;
  public
    ///  <summary><c>Creates an instance of your Sorted List using the Default Expander and Compactor Types.</c></summary>
    constructor Create(const AComparer: IADComparer<T>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Sorted List using a Custom Expander Instance, and the default Compactor Type.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const AComparer: IADComparer<T>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Sorted List using the default Expander Type, and a Custom Compactor Instance.</c></summary>
    constructor Create(const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<T>; const AInitialCapacity: Integer = 0); reintroduce; overload;
    ///  <summary><c>Creates an instance of your Sorted List using a Custom Expander and Compactor Instance.</c></summary>
    constructor Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<T>; const AInitialCapacity: Integer = 0); reintroduce; overload; virtual;
    destructor Destroy; override;

    // Management Methods
    { IADSortedList<T> }
    function Add(const AItem: T): Integer; virtual;
    procedure AddItems(const AItems: Array of T); overload; virtual;
    procedure AddItems(const AList: IADSortedList<T>); overload; virtual;
    procedure Clear; virtual;
    procedure Compact; virtual;
    function Contains(const AItem: T): Boolean; virtual;
    function ContainsAll(const AItems: Array of T): Boolean; virtual;
    function ContainsAny(const AItems: Array of T): Boolean; virtual;
    function ContainsNone(const AItems: Array of T): Boolean; virtual;
    procedure Delete(const AIndex: Integer); overload; virtual;
    procedure DeleteRange(const AFromIndex, ACount: Integer); overload; virtual;
    function EqualItems(const AList: IADSortedListReader<T>): Boolean; virtual;
    function IndexOf(const AItem: T): Integer; virtual;
    procedure Remove(const AItem: T); virtual;
    procedure RemoveItems(const AItems: Array of T); virtual;

    // Iterators
    { IADIterable<T> }
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight); overload; inline;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection = idRight); overload; inline;
    procedure Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection = idRight); overload; inline;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateBackward(const ACallback: TADListItemCallbackAnon<T>); overload; virtual;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateBackward(const ACallback: TADListItemCallbackOfObject<T>); overload; virtual;
    procedure IterateBackward(const ACallback: TADListItemCallbackUnbound<T>); overload; virtual;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateForward(const ACallback: TADListItemCallbackAnon<T>); overload; virtual;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateForward(const ACallback: TADListItemCallbackOfObject<T>); overload; virtual;
    procedure IterateForward(const ACallback: TADListItemCallbackUnbound<T>); overload; virtual;

    // Properties
    { IADCompactable }
    property Compactor: IADCollectionCompactor read GetCompactor write SetCompactor;
    { IADComparable<T> }
    property Comparer: IADComparer<T> read GetComparer write SetComparer;
    { IADExpandable }
    property Expander: IADCollectionExpander read GetExpander write SetExpander;
    { IADListSortable<T> }
    property Sorter: IADListSorter<T> read GetSorter write SetSorter;
    { IADSortedList<T> }
    property Count: Integer read GetCount;
    property IsCompact: Boolean read GetIsCompact;
    property IsEmpty: Boolean read GetIsEmpty;
    property Item[const AIndex: Integer]: T read GetItem;
  end;

  ///  <summary><c>Generic Object Sorted List Type</c></summary>
  ///  <remarks>
  ///    <para><c>Can take Ownership of its Items.</c></para>
  ///    <para><c>This type is NOT Threadsafe.</c></para>
  ///  </remarks>
  TADSortedObjectList<T: class> = class(TADSortedList<T>, IADObjectOwner)
  protected
    // Getters
    function GetOwnership: TADOwnership; virtual;
    // Setters
    procedure SetOwnership(const AOwnership: TADOwnership); virtual;
    // Management Methods
    ///  <summary><c>Override to construct an alternative Array type</c></summary>
    procedure CreateArray(const AInitialCapacity: Integer = 0); override;
  public
    // Properties
    property Ownership: TADOwnership read GetOwnership write SetOwnership;
  end;

  TADSortedCircularList<T> = class(TADCircularList<T>)
  protected
    function AddActual(const AItem: T): Integer; override;
  end;

  TADSortedCircularObjectList<T: class> = class(TADSortedCircularList<T>, IADObjectOwner)
  private
    FDefaultOwnership: TADOwnership;
  protected
    // Getters
    function GetOwnership: TADOwnership; virtual;
    // Setters
    procedure SetOwnership(const AOwnership: TADOwnership); virtual;
  protected
    procedure CreateItemArray(const ACapacity: Integer); override;
  public
    constructor Create(const AOwnership: TADOwnership; const ACapacity: Integer); reintroduce; virtual;
    destructor Destroy; override;
  end;

implementation

uses
  ADAPT.Generics.Common,
  ADAPT.Generics.Allocators,
  ADAPT.Generics.Sorters,
  ADAPT.Generics.Arrays;

{ TADList<T> }

constructor TADList<T>.Create(const AInitialCapacity: Integer = 0);
begin
  Create(ADCollectionExpanderDefault, ADCollectionCompactorDefault, AInitialCapacity);
end;

constructor TADList<T>.Create(const AExpander: IADCollectionExpander; const AInitialCapacity: Integer = 0);
begin
  Create(AExpander, ADCollectionCompactorDefault, AInitialCapacity);
end;

constructor TADList<T>.Create(const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0);
begin
  Create(ADCollectionExpanderDefault, ACompactor, AInitialCapacity);
end;

constructor TADList<T>.Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer = 0);
begin
  inherited Create;
  FSortedState := ssUnknown;
  FCount := 0;
  FCompactor := ACompactor;
  FExpander := AExpander;
  FInitialCapacity := AInitialCapacity;
  CreateArray(AInitialCapacity);
  FSorter := TADListSorterQuick<T>.Create;
end;

destructor TADList<T>.Destroy;
begin
  FExpander := nil;
  FCompactor := nil;
  inherited;
end;

procedure TADList<T>.Add(const AItem: T);
begin
  CheckExpand(1);
  AddActual(AItem);
end;

procedure TADList<T>.Add(const AList: IADList<T>);
var
  I: Integer;
begin
  CheckExpand(AList.Count);
  for I := 0 to AList.Count - 1 do
    AddActual(AList[I]);
end;

procedure TADList<T>.AddActual(const AItem: T);
begin
  FArray[FCount] := AItem;
  Inc(FCount);
  FSortedState := ssUnsorted;
end;

procedure TADList<T>.AddItems(const AItems: Array of T);
var
  I: Integer;
begin
  CheckExpand(Length(AItems));
  for I := Low(AItems) to High(AItems) do
    AddActual(AItems[I]);
end;

procedure TADList<T>.CheckCompact(const AAmount: Integer);
var
  LShrinkBy: Integer;
begin
  LShrinkBy := FCompactor.CheckCompact(FArray.Capacity, FCount, AAmount);
  if LShrinkBy > 0 then
    FArray.Capacity := FArray.Capacity - LShrinkBy;
end;

procedure TADList<T>.CheckExpand(const AAmount: Integer);
var
  LNewCapacity: Integer;
begin
  LNewCapacity := FExpander.CheckExpand(FArray.Capacity, FCount, AAmount);
  if LNewCapacity > 0 then
    FArray.Capacity := FArray.Capacity + LNewCapacity;
end;

procedure TADList<T>.Clear;
begin
  FArray.Finalize(0, FCount);
  FCount := 0;
  FArray.Capacity := FInitialCapacity;
  FSortedState := ssUnknown;
end;

procedure TADList<T>.Compact;
begin
  FArray.Capacity := FCount;
end;

procedure TADList<T>.CreateArray(const AInitialCapacity: Integer = 0);
begin
  FArray := TADArray<T>.Create(AInitialCapacity);
end;

procedure TADList<T>.Delete(const AIndex: Integer);
begin
  FArray.Finalize(AIndex, 1);
  if AIndex < FCount - 1 then
    FArray.Move(AIndex + 1, AIndex, FCount - AIndex); // Shift all subsequent items left by 1
  Dec(FCount);
  CheckCompact(1);
  FSortedState := ssUnsorted;
end;

procedure TADList<T>.DeleteRange(const AFirst, ACount: Integer);
begin
  FArray.Finalize(AFirst, ACount);
  if AFirst + FCount < FCount - 1 then
    FArray.Move(AFirst + FCount + 1, AFirst, ACount); // Shift all subsequent items left
  Dec(FCount, ACount);
  CheckCompact(ACount);
  FSortedState := ssUnsorted;
end;

function TADList<T>.GetCapacity: Integer;
begin
  Result := FArray.Capacity;
end;

function TADList<T>.GetCompactor: IADCollectionCompactor;
begin
  Result := FCompactor;
end;

function TADList<T>.GetCount: Integer;
begin
  Result := FCount;
end;

function TADList<T>.GetExpander: IADCollectionExpander;
begin
  Result := FExpander;
end;

function TADList<T>.GetInitialCapacity: Integer;
begin
  Result := FInitialCapacity;
end;

function TADList<T>.GetIsCompact: Boolean;
begin
  Result := FArray.Capacity = FCount;
end;

function TADList<T>.GetIsEmpty: Boolean;
begin
  Result := (FCount = 0);
end;

function TADList<T>.GetItem(const AIndex: Integer): T;
begin
  Result := FArray[AIndex];
end;

function TADList<T>.GetSortedState: TADSortedState;
begin
  Result := FSortedState;
end;

function TADList<T>.GetSorter: IADListSorter<T>;
begin
  Result := FSorter;
end;

procedure TADList<T>.Insert(const AItem: T; const AIndex: Integer);
begin
  //TODO -oDaniel -cTADList<T>: Implement Insert method
  FSortedState := ssUnsorted;
end;

procedure TADList<T>.InsertItems(const AItems: Array of T; const AIndex: Integer);
begin
  //TODO -oDaniel -cTADList<T>: Implement InsertItems method
  FSortedState := ssUnsorted;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADList<T>.Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight);
  begin
    case ADirection of
      idLeft: IterateBackward(ACallback);
      idRight: IterateForward(ACallback);
      else
        raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADList<T>.Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

procedure TADList<T>.Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADList<T>.IterateBackward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := FCount - 1 downto 0 do
      ACallback(FArray[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADList<T>.IterateBackward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I]);
end;

procedure TADList<T>.IterateBackward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I]);
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADList<T>.IterateForward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := 0 to FCount - 1 do
      ACallback(FArray[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADList<T>.IterateForward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I]);
end;

procedure TADList<T>.IterateForward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I]);
end;

procedure TADList<T>.SetCapacity(const ACapacity: Integer);
begin
  if ACapacity < FCount then
    raise EADGenericsCapacityLessThanCount.CreateFmt('Given Capacity of %d insufficient for a List containing %d Items.', [ACapacity, FCount])
  else
    FArray.Capacity := ACapacity;
end;

procedure TADList<T>.SetCompactor(const ACompactor: IADCollectionCompactor);
begin
  if ACompactor = nil then
    raise EADGenericsCompactorNilException.Create('Cannot assign a Nil Compactor.')
  else
    FCompactor := ACompactor;

  CheckCompact(0);
end;

procedure TADList<T>.SetExpander(const AExpander: IADCollectionExpander);
begin
  if AExpander = nil then
    raise EADGenericsExpanderNilException.Create('Cannot assign a Nil Expander.')
  else
    FExpander := AExpander;
end;

procedure TADList<T>.SetItem(const AIndex: Integer; const AItem: T);
begin
  FArray[AIndex] := AItem;
end;

procedure TADList<T>.SetSorter(const ASorter: IADListSorter<T>);
begin
  FSorter := ASorter;
end;

procedure TADList<T>.Sort(const AComparer: IADComparer<T>);
begin
  FSorter.Sort(FArray, AComparer, 0, FCount - 1);
  FSortedState := ssSorted;
end;

{ TADObjectList<T> }

constructor TADObjectList<T>.Create(const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  Create(ADCollectionExpanderDefault, ADCollectionCompactorDefault, AInitialCapacity, AOwnership);
end;

constructor TADObjectList<T>.Create(const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  Create(ADCollectionExpanderDefault, ACompactor, AInitialCapacity, AOwnership);
end;

constructor TADObjectList<T>.Create(const AExpander: IADCollectionExpander; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  Create(AExpander, ADCollectionCompactorDefault, AInitialCapacity, AOwnership);
end;

constructor TADObjectList<T>.Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AInitialCapacity: Integer; const AOwnership: TADOwnership);
begin
  inherited Create(AExpander, ACompactor, AInitialCapacity);
  TADObjectArray<T>(FArray).Ownership := AOwnership;
end;

procedure TADObjectList<T>.CreateArray(const AInitialCapacity: Integer = 0);
begin
  FArray := TADObjectArray<T>.Create(oOwnsObjects, AInitialCapacity);
end;

function TADObjectList<T>.GetOwnership: TADOwnership;
begin
  Result := TADObjectArray<T>(FArray).Ownership;
end;

procedure TADObjectList<T>.SetOwnership(const AOwnership: TADOwnership);
begin
  TADObjectArray<T>(FArray).Ownership := AOwnership;
end;

{ TADCircularList<T> }

function TADCircularList<T>.Add(const AItem: T): Integer;
begin
  Result := AddActual(AItem);
end;

function TADCircularList<T>.AddActual(const AItem: T): Integer;
var
  I: Integer;
begin
  if FCount < FItems.Capacity then
    Inc(FCount)
  else
    FItems.Delete(0);

  Result := FCount - 1;

  FItems[Result] := AItem;         // Assign the Item to the Array at the Index.
end;

procedure TADCircularList<T>.AddItems(const AItems: array of T);
var
  I: Integer;
begin
  for I := Low(AItems) to High(AItems) do
    AddActual(AItems[I]);
end;

procedure TADCircularList<T>.Clear;
begin
  FItems.Clear;
  FCount := 0;
end;

constructor TADCircularList<T>.Create(const ACapacity: Integer);
begin
  inherited Create;
  FInitialCapacity := ACapacity;
  CreateItemArray(ACapacity);
  FCount := 0;
end;

procedure TADCircularList<T>.CreateItemArray(const ACapacity: Integer);
begin
  FItems := TADArray<T>.Create(ACapacity);
end;

procedure TADCircularList<T>.Delete(const AIndex: Integer);
begin
  FItems.Finalize(AIndex, 1); // Finalize the item at the specified Index
  if AIndex < FItems.Capacity then
    FItems.Move(AIndex + 1, AIndex, FCount - AIndex); // Shift all subsequent items left by 1
  Dec(FCount); // Decrement the Count
end;

destructor TADCircularList<T>.Destroy;
begin
  inherited;
end;

function TADCircularList<T>.GetCapacity: Integer;
begin
  Result := FItems.Capacity;
end;

function TADCircularList<T>.GetCount: Integer;
begin
  Result := FCount;
end;

function TADCircularList<T>.GetInitialCapacity: Integer;
begin
  Result := FInitialCapacity;
end;

function TADCircularList<T>.GetIsCompact: Boolean;
begin
  Result := FItems.Capacity = FCount;
end;

function TADCircularList<T>.GetIsEmpty: Boolean;
begin
  Result := (FCount = 0);
end;

function TADCircularList<T>.GetItem(const AIndex: Integer): T;
begin
  Result := FItems[AIndex]; // Index Validation is now performed by TADArray<T>.GetItem
end;

function TADCircularList<T>.GetNewest: T;
var
  LIndex: Integer;
begin
  LIndex := GetNewestIndex;
  if LIndex > -1 then
    Result := FItems[LIndex];
end;

function TADCircularList<T>.GetNewestIndex: Integer;
begin
  Result := FCount - 1;
end;

function TADCircularList<T>.GetOldest: T;
var
  LIndex: Integer;
begin
  LIndex := GetOldestIndex;
  if LIndex > -1 then
    Result := FItems[LIndex];
end;

function TADCircularList<T>.GetOldestIndex: Integer;
begin
  if FCount = 0 then
    Result := -1
  else
    Result := 0;
end;

function TADCircularList<T>.GetSortedState: TADSortedState;
begin
  Result := ssUnsorted;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADCircularList<T>.Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight);
  begin
    case ADirection of
      idLeft: IterateBackward(ACallback);
      idRight: IterateForward(ACallback);
      else
        raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADCircularList<T>.Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

procedure TADCircularList<T>.Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADCircularList<T>.IterateBackward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := FCount - 1 downto 0 do
      ACallback(FItems[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADCircularList<T>.IterateBackward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FItems[I]);
end;

procedure TADCircularList<T>.IterateBackward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FItems[I]);
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADCircularList<T>.IterateForward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := 0 to FCount - 1 do
      ACallback(FItems[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADCircularList<T>.IterateForward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FItems[I]);
end;

procedure TADCircularList<T>.IterateForward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FItems[I]);
end;

procedure TADCircularList<T>.SetCapacity(const ACapacity: Integer);
begin
  //TODO -cTADCircularList<T> -oDaniel: Expand Array and repopulate with existing Items in order!
end;

{ TADCircularObjectList<T> }

constructor TADCircularObjectList<T>.Create(const AOwnership: TADOwnership; const ACapacity: Integer);
begin
  FDefaultOwnership := AOwnership;
  inherited Create(ACapacity);
end;

procedure TADCircularObjectList<T>.CreateItemArray(const ACapacity: Integer);
begin
  FItems := TADObjectArray<T>.Create(FDefaultOwnership, ACapacity);
end;

destructor TADCircularObjectList<T>.Destroy;
begin

  inherited;
end;

function TADCircularObjectList<T>.GetOwnership: TADOwnership;
begin
  Result := TADObjectArray<T>(FItems).Ownership;
end;

procedure TADCircularObjectList<T>.SetOwnership(const AOwnership: TADOwnership);
begin
  TADObjectArray<T>(FItems).Ownership := AOwnership;
end;

{ TADSortedList<T> }

function TADSortedList<T>.Add(const AItem: T): Integer;
begin
  CheckExpand(1);
  Result := AddActual(AItem);
end;

procedure TADSortedList<T>.AddItems(const AItems: array of T);
var
  I: Integer;
begin
  CheckExpand(Length(AItems));
  for I := Low(AItems) to High(AItems) do
    AddActual(AItems[I]);
end;

function TADSortedList<T>.AddActual(const AItem: T): Integer;
begin
  // TODO -oDaniel -cTADSortedList<T>: Need to add check to ensure Item not already in List. This MIGHT need to be optional!
  Result := GetSortedPosition(AItem);
  if Result = FCount then
    FArray[FCount] := AItem
  else
    FArray.Insert(AItem, Result);

  Inc(FCount);
end;

procedure TADSortedList<T>.AddItems(const AList: IADSortedList<T>);
var
  I: Integer;
begin
  CheckExpand(AList.Count);
  for I := 0 to AList.Count - 1 do
    AddActual(AList[I]);
end;

procedure TADSortedList<T>.CheckCompact(const AAmount: Integer);
var
  LShrinkBy: Integer;
begin
  LShrinkBy := FCompactor.CheckCompact(FArray.Capacity, FCount, AAmount);
  if LShrinkBy > 0 then
    FArray.Capacity := FArray.Capacity - LShrinkBy;
end;

procedure TADSortedList<T>.CheckExpand(const AAmount: Integer);
var
  LNewCapacity: Integer;
begin
  LNewCapacity := FExpander.CheckExpand(FArray.Capacity, FCount, AAmount);
  if LNewCapacity > 0 then
    FArray.Capacity := FArray.Capacity + LNewCapacity;
end;

procedure TADSortedList<T>.Clear;
begin
  FArray.Clear;
  FCount := 0;
  FArray.Capacity := FInitialCapacity;
end;

procedure TADSortedList<T>.Compact;
begin
  FArray.Capacity := FCount;
end;

function TADSortedList<T>.Contains(const AItem: T): Boolean;
var
  LIndex: Integer;
begin
  LIndex := IndexOf(AItem);
  Result := (LIndex > -1);
end;

function TADSortedList<T>.ContainsAll(const AItems: array of T): Boolean;
var
  I: Integer;
begin
  Result := True; // Optimistic
  for I := Low(AItems) to High(AItems) do
    if (not Contains(AItems[I])) then
    begin
      Result := False;
      Break;
    end;
end;

function TADSortedList<T>.ContainsAny(const AItems: array of T): Boolean;
var
  I: Integer;
begin
  Result := False; // Pessimistic
  for I := Low(AItems) to High(AItems) do
    if Contains(AItems[I]) then
    begin
      Result := True;
      Break;
    end;
end;

function TADSortedList<T>.ContainsNone(const AItems: array of T): Boolean;
begin
  Result := (not ContainsAny(AItems));
end;

constructor TADSortedList<T>.Create(const AComparer: IADComparer<T>; const AInitialCapacity: Integer);
begin
  Create(ADCollectionExpanderDefault, ADCollectionCompactorDefault, AComparer, AInitialCapacity);
end;

constructor TADSortedList<T>.Create(const AExpander: IADCollectionExpander; const AComparer: IADComparer<T>; const AInitialCapacity: Integer);
begin
  Create(AExpander, ADCollectionCompactorDefault, AComparer, AInitialCapacity);
end;

constructor TADSortedList<T>.Create(const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<T>; const AInitialCapacity: Integer);
begin
  Create(ADCollectionExpanderDefault, ACompactor, AComparer, AInitialCapacity);
end;

constructor TADSortedList<T>.Create(const AExpander: IADCollectionExpander; const ACompactor: IADCollectionCompactor; const AComparer: IADComparer<T>; const AInitialCapacity: Integer);
begin
  inherited Create;
  FCount := 0;
  FExpander := AExpander;
  FCompactor := ACompactor;
  FComparer := AComparer;
  FSorter := TADListSorterQuick<T>.Create;
  FInitialCapacity := AInitialCapacity;
  CreateArray(AInitialCapacity);
end;

procedure TADSortedList<T>.CreateArray(const AInitialCapacity: Integer);
begin
  FArray := TADArray<T>.Create(AInitialCapacity);
end;

procedure TADSortedList<T>.Delete(const AIndex: Integer);
begin
  FArray.Delete(AIndex);
  Dec(FCount);
end;

procedure TADSortedList<T>.DeleteRange(const AFromIndex, ACount: Integer);
var
  I: Integer;
begin
  for I := AFromIndex + ACount - 1 downto AFromIndex do
    Delete(I);
end;

destructor TADSortedList<T>.Destroy;
begin

  inherited;
end;

function TADSortedList<T>.EqualItems(const AList: IADSortedListReader<T>): Boolean;
var
  I: Integer;
begin
  Result := AList.Count = FCount;
  if Result then
    for I := 0 to AList.Count - 1 do
      if (not FComparer.AEqualToB(AList[I], FArray[I])) then
      begin
        Result := False;
        Break;
      end;
end;

function TADSortedList<T>.GetCapacity: Integer;
begin
  Result := FArray.Capacity;
end;

function TADSortedList<T>.GetCompactor: IADCollectionCompactor;
begin
  Result := FCompactor;
end;

function TADSortedList<T>.GetComparer: IADComparer<T>;
begin
  Result := FComparer;
end;

function TADSortedList<T>.GetCount: Integer;
begin
  Result := FCount;
end;

function TADSortedList<T>.GetExpander: IADCollectionExpander;
begin
  Result := FExpander;
end;

function TADSortedList<T>.GetInitialCapacity: Integer;
begin
  Result := FInitialCapacity;
end;

function TADSortedList<T>.GetIsCompact: Boolean;
begin
  Result := FArray.Capacity = FCount;
end;

function TADSortedList<T>.GetIsEmpty: Boolean;
begin
  Result := (FCount = 0);
end;

function TADSortedList<T>.GetItem(const AIndex: Integer): T;
begin
  Result := FArray[AIndex];
end;

function TADSortedList<T>.GetSortedPosition(const AItem: T): Integer;
var
  LIndex, LLow, LHigh: Integer;
begin
  Result := 0;
  LLow := 0;
  LHigh := FCount - 1;
  if LHigh = -1 then
    Exit;
  if LLow < LHigh then
  begin
    while (LHigh - LLow > 1) do
    begin
      LIndex := (LHigh + LLow) div 2;
      if FComparer.ALessThanOrEqualToB(AItem, FArray[LIndex]) then
        LHigh := LIndex
      else
        LLow := LIndex;
    end;
  end;
  if FComparer.ALessThanB(FArray[LHigh], AItem) then
    Result := LHigh + 1
  else if FComparer.ALessThanB(FArray[LLow], AItem) then
    Result := LLow + 1
  else
    Result := LLow;
end;

function TADSortedList<T>.GetSortedState: TADSortedState;
begin
  Result := ssSorted;
end;

function TADSortedList<T>.GetSorter: IADListSorter<T>;
begin
  Result := FSorter;
end;

function TADSortedList<T>.IndexOf(const AItem: T): Integer;
var
  LLow, LHigh, LMid: Integer;
begin
  Result := -1; // Pessimistic
  LLow := 0;
  LHigh := FCount - 1;
  repeat
    LMid := (LLow + LHigh) div 2;
    if FComparer.AEqualToB(FArray[LMid], AItem) then
    begin
      Result := LMid;
      Break;
    end
    else if FComparer.ALessThanB(AItem, FArray[LMid]) then
      LHigh := LMid - 1
    else
      LLow := LMid + 1;
  until LHigh < LLow;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADSortedList<T>.Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight);
  begin
    case ADirection of
      idLeft: IterateBackward(ACallback);
      idRight: IterateForward(ACallback);
      else
        raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
    end;
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADSortedList<T>.Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

procedure TADSortedList<T>.Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection);
begin
  case ADirection of
    idLeft: IterateBackward(ACallback);
    idRight: IterateForward(ACallback);
    else
      raise EADGenericsIterateDirectionUnknownException.Create('Unhandled Iterate Direction given.');
  end;
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADSortedList<T>.IterateBackward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := FCount - 1 downto 0 do
      ACallback(FArray[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADSortedList<T>.IterateBackward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I]);
end;

procedure TADSortedList<T>.IterateBackward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    ACallback(FArray[I]);
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADSortedList<T>.IterateForward(const ACallback: TADListItemCallbackAnon<T>);
  var
    I: Integer;
  begin
    for I := 0 to FCount - 1 do
      ACallback(FArray[I]);
  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADSortedList<T>.IterateForward(const ACallback: TADListItemCallbackOfObject<T>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I]);
end;

procedure TADSortedList<T>.IterateForward(const ACallback: TADListItemCallbackUnbound<T>);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    ACallback(FArray[I]);
end;

procedure TADSortedList<T>.Remove(const AItem: T);
var
  LIndex: Integer;
begin
  LIndex := IndexOf(AItem);
  if LIndex > -1 then
    Delete(LIndex);
end;

procedure TADSortedList<T>.RemoveItems(const AItems: array of T);
var
  I: Integer;
begin
  for I := Low(AItems) to High(AItems) do
    Remove(AItems[I]);
end;

procedure TADSortedList<T>.SetCapacity(const ACapacity: Integer);
begin
  if ACapacity < FCount then
    raise EADGenericsCapacityLessThanCount.CreateFmt('Given Capacity of %d insufficient for a List containing %d Items.', [ACapacity, FCount])
  else
    FArray.Capacity := ACapacity;
end;

procedure TADSortedList<T>.SetCompactor(const ACompactor: IADCollectionCompactor);
begin
  FCompactor := ACompactor;
  CheckCompact(0);
end;

procedure TADSortedList<T>.SetComparer(const AComparer: IADComparer<T>);
begin
  FComparer := AComparer;
  FSorter.Sort(FArray, AComparer, 0, FCount - 1);
end;

procedure TADSortedList<T>.SetExpander(const AExpander: IADCollectionExpander);
begin
  FExpander := AExpander;
end;

procedure TADSortedList<T>.SetSorter(const ASorter: IADListSorter<T>);
begin
  FSorter := ASorter;
end;

{ TADSortedObjectList<T> }

procedure TADSortedObjectList<T>.CreateArray(const AInitialCapacity: Integer);
begin
  FArray := TADObjectArray<T>.Create(oOwnsObjects, AInitialCapacity);
end;

function TADSortedObjectList<T>.GetOwnership: TADOwnership;
begin
  Result := TADObjectArray<T>(FArray).Ownership;
end;

procedure TADSortedObjectList<T>.SetOwnership(const AOwnership: TADOwnership);
begin
  TADObjectArray<T>(FArray).Ownership := AOwnership;
end;

{ TADSortedCircularList<T> }

function TADSortedCircularList<T>.AddActual(const AItem: T): Integer;
begin
  inherited; // TODO -oDaniel -cTADSortedCircularList<T>: Implement Sorted Insertion
end;

{ TADSortedCircularObjectList<T> }

constructor TADSortedCircularObjectList<T>.Create(const AOwnership: TADOwnership; const ACapacity: Integer);
begin
  FDefaultOwnership := AOwnership;
  inherited Create(ACapacity);
end;

procedure TADSortedCircularObjectList<T>.CreateItemArray(const ACapacity: Integer);
begin
  FItems := TADObjectArray<T>.Create(FDefaultOwnership, ACapacity);
end;

destructor TADSortedCircularObjectList<T>.Destroy;
begin

  inherited;
end;

function TADSortedCircularObjectList<T>.GetOwnership: TADOwnership;
begin
  Result := TADObjectArray<T>(FItems).Ownership;
end;

procedure TADSortedCircularObjectList<T>.SetOwnership(const AOwnership: TADOwnership);
begin
  TADObjectArray<T>(FItems).Ownership := AOwnership;
end;

end.
