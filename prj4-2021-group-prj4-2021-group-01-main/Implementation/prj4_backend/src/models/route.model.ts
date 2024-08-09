import {Entity, model, property} from '@loopback/repository';

@model({settings: {strict: false}})
export class Route extends Entity {
  @property({
    type: 'number',
    id: true,
    generated: true,
  })
  ID?: number;

  @property({
    type: 'string',
  })
  R_NAME?: string;

  @property({
    type: 'string',
  })
  PIC?: string;

  @property({
    type: 'number',
  })
  U_ID?: number;

  // Define well-known properties here

  // Indexer property to allow additional data
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  [prop: string]: any;

  constructor(data?: Partial<Route>) {
    super(data);
  }
}

export interface RouteRelations {
  // describe navigational properties here
}

export type RouteWithRelations = Route & RouteRelations;
