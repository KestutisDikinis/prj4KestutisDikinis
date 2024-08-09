import {Entity, model, property} from '@loopback/repository';

@model({settings: {strict: false}})
export class RPoint extends Entity {
  @property({
    type: 'number',
    id: true,
    generated: true,
  })
  ID?: number;

  @property({
    type: 'string',
    required: true,
  })
  LATITUDE: string;

  @property({
    type: 'string',
    required: true,
  })
  LONGITUDE: string;

  @property({
    type: 'number',
    required: true,
  })
  R_POS: number;

  @property({
    type: 'number',
    required: true,
  })
  ROUTE_ID: number;

  // Define well-known properties here

  // Indexer property to allow additional data
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  [prop: string]: any;

  constructor(data?: Partial<RPoint>) {
    super(data);
  }
}

export interface RPointRelations {
  // describe navigational properties here
}

export type RPointWithRelations = RPoint & RPointRelations;
