import {Entity, model, property} from '@loopback/repository';

@model()
export class UserProfile extends Entity {
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
  USR_NAME: string;

  @property({
    type: 'string',
    required: true,
  })
  EMAIL: string;

  @property({
    type: 'string',
    required: true,
  })
  PASS: string;

  @property({
    type: 'string',
    required: false,
  })
  FIRSTNAME: string;

  @property({
    type: 'string',
    required: false,
  })
  LASTNAME: string;

  @property({
    type: 'string',
    required: false,
  })
  BIRTHDAY: string;

  @property({
    type: 'string',
    required: false,
  })
  CITY: string;

  @property({
    type: 'string',
    required: false,
  })
  PRO_PIC: string;

  constructor(data?: Partial<UserProfile>) {
    super(data);
  }
}

export interface UserProfileRelations {
  // describe navigational properties here
}

export type UserProfileWithRelations = UserProfile & UserProfileRelations;
