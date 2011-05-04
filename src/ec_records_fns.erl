-module(ec_records_fns).
-export([
	 get_rec_value/3,
	 set_rec_value/4,
	 set_multiple_values/3
	]).


%% @edoc Allows to dynamically find a value in the record of the given type
%% http://progexpr.blogspot.com/2007/04/simple-dynamic-record-access.html    
%% extra discussion
%%http://www.reddit.com/r/programming/comments/1i147/simple_dynamic_record_access_in_erlang/c1i1kd
%% http://chlorophil.blogspot.com/2007/04/dynamic-record-access-functions-with.html


%% get value in a record by a key
-spec(get_rec_value(Key::atom(), any(), [atom()]) -> any()).
get_rec_value(Key, Rec, RecordInfo) ->
    case find(Key, RecordInfo) of
	not_found ->
	    undefined;
	Num ->
	    element(Num + 1, Rec)
    end.

%% set value in a record by a key
set_rec_value(Key, Value, Rec, RecordInfo) ->
    RecList = tuple_to_list(Rec),
    case find(Key, RecordInfo) of
	not_found ->
	    Rec;
	Num ->
	    List1 = lists:sublist(RecList, Num),
	    List2 = lists:sublist(RecList, Num + 2, length(RecList)),
	    list_to_tuple(List1 ++ [Value] ++ List2)
    end.

set_multiple_values(Rec, _RecordInfo, []) ->
    Rec;
set_multiple_values(Rec, RecordInfo, [{Key, Value}|T]) ->
    set_multiple_values(set_rec_value(Key, Value, Rec, RecordInfo), RecordInfo, T).


find(Item, List) ->
    find_(Item, List, 1).
find_(_Item, [], _) -> not_found;
find_(Item, [H|T], Count) ->
    case H of
	Item ->
	    Count;
	_ ->
	    find_(Item, T, Count+1)
    end.

