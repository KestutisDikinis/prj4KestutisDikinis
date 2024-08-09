import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {DbDataSource} from '../datasources';
import {Points, PointsRelations} from '../models';

export class PointsRepository extends DefaultCrudRepository<
  Points,
  typeof Points.prototype.U_ID,
  PointsRelations
> {
  constructor(
    @inject('datasources.db') dataSource: DbDataSource,
  ) {
    super(Points, dataSource);
  }
}
