import {Entity, model, property} from '@loopback/repository';

@model({settings: {strict: false}})
export class Points extends Entity {
  @property({
    type: 'number', 
    required: true,
  })
  U_ID?: number;

  @property({
    type: 'number',
    required: true,
  })
  AMOUNT: number;

  @property({
    type: 'number',
    required: true,
  })
  SOURCE: number;

  @property({
    type: 'number',
  })
  R_ID?: number;

  @property({
    type: 'number',
    id: true,
    generated: true,
  })
  ID?: number;
  // Define well-known properties here

  // Indexer property to allow additional data
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  [prop: string]: any;

  constructor(data?: Partial<Points>) {
    super(data);
  }
}

export interface PointsRelations {
  // describe navigational properties here
}

export type PointsWithRelations = Points & PointsRelations;
