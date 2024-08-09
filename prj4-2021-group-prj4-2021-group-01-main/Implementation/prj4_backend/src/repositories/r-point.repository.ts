import {inject} from '@loopback/core';
import {DefaultCrudRepository} from '@loopback/repository';
import {DbDataSource} from '../datasources';
import {RPoint, RPointRelations} from '../models';

export class RPointRepository extends DefaultCrudRepository<
  RPoint,
  typeof RPoint.prototype.ID,
  RPointRelations
> {
  constructor(
    @inject('datasources.db') dataSource: DbDataSource,
  ) {
    super(RPoint, dataSource);
  }
}
