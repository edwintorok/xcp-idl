
(** The Delay module here implements simple cancellable delays. *)
module Delay :
  sig
    type t

    (** Makes a Delay.t *)
    val make : unit -> t

    (** Wait for the specified amount of time. Returns true if we waited
        the full length of time, false if we were woken *)
    val wait : t -> float -> bool

    (** Signal anyone currently waiting with the Delay.t *)
    val signal : t -> unit
  end

(** The type of a scheduler *)
type t

(** The handle for referring to an item that has been scheduled *)
type handle

(** Creates a scheduler *)
val make : unit -> t

(** Items can be scheduled as a delta measured in seconds from now. *)
type time = Delta of int

(** This module is for dumping the state of a scheduler *)
module Dump :
  sig
    type u = { time : int64; thing : string; }
    type dump = u list
    val rpc_of_dump : dump -> Rpc.t
    val dump_of_rpc : Rpc.t -> dump
    val make : t -> dump
  end

(** Insert a one-shot item into the scheduler. *)
val one_shot : t -> time -> string -> (unit -> unit) -> handle

(** Cancel an item *)
val cancel : t -> handle -> unit

(** shutdown a scheduler. Any item currently scheduled will not
    be executed. The scheduler cannot be restarted. *)
val shutdown : t -> unit
