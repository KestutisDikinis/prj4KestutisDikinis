import {
  Count,
  CountSchema,
  Filter,
  FilterExcludingWhere,
  repository,
  Where,
} from '@loopback/repository';
import {
  post,
  param,
  get,
  getModelSchemaRef,
  patch,
  put,
  del,
  requestBody,
  response,
} from '@loopback/rest';
import {Points} from '../models';
import {PointsRepository} from '../repositories';

export class PointControllerController {
  constructor(
    @repository(PointsRepository)
    public pointsRepository : PointsRepository,
  ) {}

  @post('/points')
  @response(200, {
    description: 'Points model instance',
    content: {'application/json': {schema: getModelSchemaRef(Points)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Points, {
            title: 'NewPoints',
            exclude: ['ID'],
          }),
        },
      },
    })
    points: Omit<Points, 'ID'>,
  ): Promise<Points> {
    return this.pointsRepository.create(points);
  }

  @get('/points/count')
  @response(200, {
    description: 'Points model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(Points) where?: Where<Points>,
  ): Promise<Count> {
    return this.pointsRepository.count(where);
  }

  @get('/points')
  @response(200, {
    description: 'Array of Points model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(Points, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(Points) filter?: Filter<Points>,
  ): Promise<Points[]> {
    return this.pointsRepository.find(filter);
  }

  @patch('/points')
  @response(200, {
    description: 'Points PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Points, {partial: true}),
        },
      },
    })
    points: Points,
    @param.where(Points) where?: Where<Points>,
  ): Promise<Count> {
    return this.pointsRepository.updateAll(points, where);
  }

  @get('/points/{id}')
  @response(200, {
    description: 'Points model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(Points, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.filter(Points, {exclude: 'where'}) filter?: FilterExcludingWhere<Points>
  ): Promise<Points> {
    return this.pointsRepository.findById(id, filter);
  }

  @patch('/points/{id}')
  @response(204, {
    description: 'Points PATCH success',
  })
  async updateById(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(Points, {partial: true}),
        },
      },
    })
    points: Points,
  ): Promise<void> {
    await this.pointsRepository.updateById(id, points);
  }

  @put('/points/{id}')
  @response(204, {
    description: 'Points PUT success',
  })
  async replaceById(
    @param.path.number('id') id: number,
    @requestBody() points: Points,
  ): Promise<void> {
    await this.pointsRepository.replaceById(id, points);
  }

  @del('/points/{id}')
  @response(204, {
    description: 'Points DELETE success',
  })
  async deleteById(@param.path.number('id') id: number): Promise<void> {
    await this.pointsRepository.deleteById(id);
  }
}
